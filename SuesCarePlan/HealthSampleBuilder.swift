//
//  HealthSampleBuilder.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import ResearchKit

/**
 A protocol that defines the methods and properties required to be able to save
 an `ORKTaskResult` to a `ORKCarePlanStore` with an associated `HKQuantitySample`.
 */
protocol HealthSampleBuilder {
    var quantityType: HKQuantityType { get }
    
    var unit: HKUnit { get }
    
    func buildSampleWithTaskResult(result: ORKTaskResult) -> HKQuantitySample
    
    func localizedUnitForSample(sample: HKQuantitySample) -> String
}
