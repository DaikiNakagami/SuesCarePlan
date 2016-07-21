//
//  BuildInsightsOperation.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import CareKit

class BuildInsightsOperation: NSOperation {
    
    // MARK: Properties
    
    var medicationEvents: DailyEvents?
    
    var kneePainEvents: DailyEvents?
    
    private(set) var insights = [OCKInsightItem.emptyInsightsMessage()]
    
    // MARK: NSOperation
    
    override func main() {
        // Do nothing if the operation has been cancelled.
        guard !cancelled else { return }
        
        // Create an array of insights.
        var newInsights = [OCKInsightItem]()
        
        if let insight = createMedicationAdherenceInsight() {
            newInsights.append(insight)
        }
        
        if let insight = createKneePainInsight() {
            newInsights.append(insight)
        }
        
        // Store any new insights thate were created.
        if !newInsights.isEmpty {
            insights = newInsights
        }
    }
    
    // MARK: Convenience
    
    func createMedicationAdherenceInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let medicationEvents = medicationEvents else { return nil }
        
        // Determine the start date for the previous week.
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        
        let components = NSDateComponents()
        components.day = -7
        let startDate = calendar.weekDatesForDate(calendar.dateByAddingComponents(components, toDate: now, options: [])!).start
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in 0..<7 {
            components.day = offset
            let dayDate = calendar.dateByAddingComponents(components, toDate: startDate, options: [])!
            let dayComponents = NSDateComponents(date: dayDate, calendar: calendar)
            let eventsForDay = medicationEvents[dayComponents]
            
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay {
                if event.state == .Completed {
                    completedEventCount += 1
                }
            }
        }
        
        guard totalEventCount > 0 else { return nil }
        
        // Calculate the percentage of completed events.
        let medicationAdherence = Float(completedEventCount) / Float(totalEventCount)
        
        // Create an `OCKMessageItem` describing medical adherence.
        let percentageFormatter = NSNumberFormatter()
        percentageFormatter.numberStyle = .PercentStyle
        let formattedAdherence = percentageFormatter.stringFromNumber(medicationAdherence)!
        
        let insight = OCKMessageItem(title: "Medication Adherence", text: "Your medication adherence was \(formattedAdherence) last week.", tintColor: Colors.Pink.color, messageType: .Tip)
        
        return insight
    }
    
    func createKneePainInsight() -> OCKInsightItem? {
        // Make sure there are events to parse.
        guard let medicationEvents = medicationEvents, kneePainEvents = kneePainEvents else { return nil }
        
        // Determine the date to start pain/medication comparisons from.
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.day = -7
        
        let startDate = calendar.dateByAddingComponents(components, toDate: NSDate(), options: [])!
        
        // Create formatters for the data.
        let dayOfWeekFormatter = NSDateFormatter()
        dayOfWeekFormatter.dateFormat = "E"
        
        let shortDateFormatter = NSDateFormatter()
        shortDateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("Md", options: 0, locale: shortDateFormatter.locale)
        
        let percentageFormatter = NSNumberFormatter()
        percentageFormatter.numberStyle = .PercentStyle
        
        /*
         Loop through 7 days, collecting medication adherance and pain scores
         for each.
         */
        var medicationValues = [Float]()
        var medicationLabels = [String]()
        var painValues = [Int]()
        var painLabels = [String]()
        var axisTitles = [String]()
        var axisSubtitles = [String]()
        
        for offset in 0..<7 {
            // Determine the day to components.
            components.day = offset
            let dayDate = calendar.dateByAddingComponents(components, toDate: startDate, options: [])!
            let dayComponents = NSDateComponents(date: dayDate, calendar: calendar)
            
            // Store the pain result for the current day.
            if let result = kneePainEvents[dayComponents].first?.result, score = Int(result.valueString) where score > 0 {
                painValues.append(score)
                painLabels.append(result.valueString)
            }
            else {
                painValues.append(0)
                painLabels.append(NSLocalizedString("N/A", comment: ""))
            }
            
            // Store the medication adherance value for the current day.
            let medicationEventsForDay = medicationEvents[dayComponents]
            if let adherence = percentageEventsCompleted(medicationEventsForDay) where adherence > 0.0 {
                // Scale the adherance to the same 0-10 scale as pain values.
                let scaledAdeherence = adherence * 10.0
                
                medicationValues.append(scaledAdeherence)
                medicationLabels.append(percentageFormatter.stringFromNumber(adherence)!)
            }
            else {
                medicationValues.append(0.0)
                medicationLabels.append(NSLocalizedString("N/A", comment: ""))
            }
            
            axisTitles.append(dayOfWeekFormatter.stringFromDate(dayDate))
            axisSubtitles.append(shortDateFormatter.stringFromDate(dayDate))
        }
        
        // Create a `OCKBarSeries` for each set of data.
        let painBarSeries = OCKBarSeries(title: "Pain", values: painValues, valueLabels: painLabels, tintColor: Colors.Blue.color)
        let medicationBarSeries = OCKBarSeries(title: "Medication Adherence", values: medicationValues, valueLabels: medicationLabels, tintColor: Colors.LightBlue.color)
        
        /*
         Add the series to a chart, specifing the scale to use for the chart
         rather than having CareKit scale the bars to fit.
         */
        let chart = OCKBarChart(title: "Knee Pain",
                                text: nil,
                                tintColor: Colors.Blue.color,
                                axisTitles: axisTitles,
                                axisSubtitles: axisSubtitles,
                                dataSeries: [painBarSeries, medicationBarSeries],
                                minimumScaleRangeValue: 0,
                                maximumScaleRangeValue: 10)
        
        return chart
    }
    
    /**
     For a given array of `OCKCarePlanEvent`s, returns the percentage that are
     marked as completed.
     */
    private func percentageEventsCompleted(events: [OCKCarePlanEvent]) -> Float? {
        guard !events.isEmpty else { return nil }
        
        let completedCount = events.filter({ event in
            event.state == .Completed
        }).count
        
        return Float(completedCount) / Float(events.count)
    }
}

/**
 An extension to `SequenceType` whose elements are `OCKCarePlanEvent`s. The
 extension adds a method to return the first element that matches the day
 specified by the supplied `NSDateComponents`.
 */
extension SequenceType where Generator.Element: OCKCarePlanEvent {
    
    func eventForDay(dayComponents: NSDateComponents) -> Generator.Element? {
        for event in self where
            event.date.year == dayComponents.year &&
                event.date.month == dayComponents.month &&
                event.date.day == dayComponents.day {
                    return event
        }
        
        return nil
    }
}
