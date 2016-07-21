//
//  Mood.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import ResearchKit
import CareKit

/**
 Struct that conforms to the `Assessment` protocol to define a mood
 assessment.
 */
struct Mood: Assessment {
    // MARK: Activity
    
    let activityType: ActivityType = .Mood
    
    func carePlanActivity() -> OCKCarePlanActivity {
        // Create a weekly schedule.
        let startDate = NSDateComponents(year: 2016, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklyScheduleWithStartDate(startDate, occurrencesOnEachDay: [1, 1, 1, 1, 1, 1, 1])
        
        // Get the localized strings to use for the assessment.
        let title = NSLocalizedString("Mood", comment: "")
        let summary = NSLocalizedString("So, how did you feel today?", comment: "")
        
        let activity = OCKCarePlanActivity.assessmentWithIdentifier(
            activityType.rawValue,
            groupIdentifier: nil,
            title: title,
            text: summary,
            tintColor: Colors.Green.color,
            resultResettable: false,
            schedule: schedule,
            userInfo: nil
        )
        
        return activity
    }
    
    // MARK: Assessment
    
    func task() -> ORKTask {
        // Get the localized strings to use for the task.
        let question = NSLocalizedString("On a scale from 1 to 10, how would you rate your mood today?", comment: "")
        let maximumValueDescription = NSLocalizedString("Good", comment: "")
        let minimumValueDescription = NSLocalizedString("Bad", comment: "")
        
        // Create a question and answer format.
        let answerFormat = ORKScaleAnswerFormat(
            maximumValue: 10,
            minimumValue: 1,
            defaultValue: -1,
            step: 1,
            vertical: false,
            maximumValueDescription: maximumValueDescription,
            minimumValueDescription: minimumValueDescription
        )
        
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: question, answer: answerFormat)
        questionStep.optional = false
        
        // Create an ordered task with a single question.
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
        
        return task
    }
}
