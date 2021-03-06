//
//  Weight.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//


import ResearchKit
import CareKit

/**
 Struct that conforms to the `Sample` protocol to define a weight assessment.
 */
struct Weight: Assessment, HealthSampleBuilder {
    // MARK: Activity properties
    
    let activityType: ActivityType = .Weight
    
    // MARK: HealthSampleBuilder Properties
    
    let quantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
    
    let unit = HKUnit.poundUnit()
    
    // MARK: Activity
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = NSDateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklyScheduleWithStartDate(startDate, occurrencesOnEachDay: [1, 0, 0, 0, 0, 0, 0])
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Weight", comment: "")
        let summary = NSLocalizedString("Early morning", comment: "")
        
        let activity = OCKCarePlanActivity.assessmentWithIdentifier(
            activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.Yellow.color,
            resultResettable: false,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        // Get the localized strings to use for the task.
        let answerFormat = ORKHealthKitQuantityTypeAnswerFormat(quantityType: quantityType, unit: unit, style: .Decimal)
        
        // Create a question.
        let title = NSLocalizedString("Input your weight", comment: "")
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: title, answer: answerFormat)
        questionStep.optional = false
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
        
        return task
    }
    
    // MARK: HealthSampleBuilder
    
    /// Builds a `HKQuantitySample` from the information in the supplied `ORKTaskResult`.
    func buildSampleWithTaskResult(result: ORKTaskResult) -> HKQuantitySample {
        // Get the first result for the first step of the task result.
        guard let firstResult = result.firstResult as? ORKStepResult, stepResult = firstResult.results?.first else { fatalError("Unexepected task results") }
        
        // Get the numeric answer for the result.
        guard let weightResult = stepResult as? ORKNumericQuestionResult, weightAnswer = weightResult.numericAnswer else { fatalError("Unable to determine result answer") }
        
        // Create a `HKQuantitySample` for the answer.
        let quantity = HKQuantity(unit: unit, doubleValue: weightAnswer.doubleValue)
        let now = NSDate()
        
        return HKQuantitySample(type: quantityType, quantity: quantity, startDate: now, endDate: now)
    }
    
    /**
     Uses an NSMassFormatter to determine the string to use to represent the
     supplied `HKQuantitySample`.
     */
    func localizedUnitForSample(sample: HKQuantitySample) -> String {
        let formatter = NSMassFormatter()
        formatter.forPersonMassUse = true
        formatter.unitStyle = .Short
        
        let value = sample.quantity.doubleValueForUnit(unit)
        let formatterUnit = NSMassFormatterUnit.Pound
        
        return formatter.unitStringFromValue(value, unit: formatterUnit)
    }
}
