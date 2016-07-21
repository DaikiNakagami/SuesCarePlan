//
//  TakeParacetamol.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import CareKit

/**
 Struct that conforms to the `Activity` protocol to define an activity to take
 paracetamol.
 */
struct TakeParacetamol: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .TakeParacetamol
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = NSDateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklyScheduleWithStartDate(startDate, occurrencesOnEachDay: [6, 6, 6, 6, 6, 6, 6])
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Paracetamol", comment: "")
        let summary = NSLocalizedString("500mg", comment: "")
        let instructions = NSLocalizedString("Take with food, 3 times a day", comment: "")
        
        let activity = OCKCarePlanActivity.interventionWithIdentifier(
            activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.Red.color,
            instructions: instructions,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }
}
