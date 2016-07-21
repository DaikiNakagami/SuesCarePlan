//
//  Activity.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import CareKit

/**
 Protocol that defines the properties and methods for sample activities.
 */
protocol Activity {
    var activityType: ActivityType { get }
    
    func carePlanActivity() -> OCKCarePlanActivity
}


/**
 Enumeration of strings used as identifiers for the `SampleActivity`s used in
 the app.
 */
enum ActivityType: String {
    case OutdoorWalk
    case TakeMedication
    case TakeParacetamol
    case TakeExercise
    
    case KneePain
    case Mood
    case Weight
}
