//
//  TakeExercise.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import CareKit

struct TakeExercise: Activity {
    // MARK: Activity
    
    let activityType: ActivityType = .TakeExercise
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = NSDateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklyScheduleWithStartDate(startDate, occurrencesOnEachDay: [2, 2, 2, 2, 2, 2, 2])
        
        // Get the localized strings to use for the activity.
        let title = NSLocalizedString("Osteoarthritis Excerises", comment: "")
        let summary = NSLocalizedString("10 mins", comment: "")
        let instructions = NSLocalizedString("Execute your specialised exercises as directed below.", comment: "")
        
        let activity = OCKCarePlanActivity.interventionWithIdentifier(
            activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.Blue.color,
            instructions: instructions,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }
}
