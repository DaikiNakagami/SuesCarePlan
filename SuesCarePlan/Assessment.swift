//
//  Assessment.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import CareKit
import ResearchKit

/**
 Protocol that adds a method to the `Activity` protocol that returns an `ORKTask`
 to present to the user.
 */
protocol Assessment: Activity {
    func task() -> ORKTask
}


/**
 Extends instances of `Assessment` to add a method that returns a
 `OCKCarePlanEventResult` for a `OCKCarePlanEvent` and `ORKTaskResult`. The
 `OCKCarePlanEventResult` can then be written to a `OCKCarePlanStore`.
 */
extension Assessment {
    func buildResultForCarePlanEvent(event: OCKCarePlanEvent, taskResult: ORKTaskResult) -> OCKCarePlanEventResult {
        // Get the first result for the first step of the task result.
        guard let firstResult = taskResult.firstResult as? ORKStepResult, stepResult = firstResult.results?.first else { fatalError("Unexepected task results") }
        
        // Determine what type of result should be saved.
        if let scaleResult = stepResult as? ORKScaleQuestionResult, answer = scaleResult.scaleAnswer {
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: "out of 10", userInfo: nil)
        }
        else if let numericResult = stepResult as? ORKNumericQuestionResult, answer = numericResult.numericAnswer {
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: numericResult.unit, userInfo: nil)
        }
        
        fatalError("Unexpected task result type")
    }
}
