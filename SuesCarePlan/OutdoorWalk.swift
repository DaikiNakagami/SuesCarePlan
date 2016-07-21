//
//  OutdoorWalk.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import CareKit

/**
 Struct that conforms to the `Activity` protocol to define an outdoor walking
 activity.
 */
struct OutdoorWalk: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .OutdoorWalk
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = NSDateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklyScheduleWithStartDate(startDate, occurrencesOnEachDay: [0, 2, 2, 2, 2, 2, 0])
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Outdoor walk", comment: "")
        let summary = NSLocalizedString("20 mins", comment: "")
        let instructions = NSLocalizedString("Take the puppies for a leisurely walk.", comment: "")
        
        // Create the intervention activity.
        let activity = OCKCarePlanActivity.interventionWithIdentifier(
            activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.Purple.color,
            instructions: instructions,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }
}