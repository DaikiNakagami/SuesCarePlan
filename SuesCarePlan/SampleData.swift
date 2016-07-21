//
//  SampleData.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//


import ResearchKit
import CareKit

class SampleData: NSObject {
    
    // MARK: Properties
    
    /// An array of `Activity`s used in the app.
    let activities: [Activity] = [
        OutdoorWalk(),
        TakeMedication(),
        TakeParacetamol(),
        TakeExercise(),
        KneePain(),
        Mood(),
        Weight()
    ]
    
    /**
     An array of `OCKContact`s to display on the Connect view.
     */
    let contacts: [OCKContact] = [
        OCKContact(contactType: .CareTeam,
            name: "Dr. Maria Ruiz",
            relation: "Physician",
            tintColor: Colors.Yellow.color,
            phoneNumber: CNPhoneNumber(stringValue: "888-555-5512"),
            messageNumber: CNPhoneNumber(stringValue: "888-555-5512"),
            emailAddress: "mruiz2@mac.com",
            monogram: "MR",
            image: nil),
        
        OCKContact(contactType: .CareTeam,
            name: "Bill James",
            relation: "Nurse",
            tintColor: Colors.Green.color,
            phoneNumber: CNPhoneNumber(stringValue: "888-555-5512"),
            messageNumber: CNPhoneNumber(stringValue: "888-555-5512"),
            emailAddress: "billjames2@mac.com",
            monogram: "BJ",
            image: nil),
        
        OCKContact(contactType: .Personal,
            name: "Graham Barker",
            relation: "Husband",
            tintColor: Colors.Blue.color,
            phoneNumber: CNPhoneNumber(stringValue: "075-9053-2804"),
            messageNumber: CNPhoneNumber(stringValue: "075-9053-2804"),
            emailAddress: "graham.barker@me.com",
            monogram: "GB",
            image: nil)
    ]
    
    // MARK: Initialization
    
    required init(carePlanStore: OCKCarePlanStore) {
        super.init()
        
        // Populate the store with the sample activities.
        for sampleActivity in activities {
            let carePlanActivity = sampleActivity.carePlanActivity()
            
            carePlanStore.addActivity(carePlanActivity) { success, error in
                if !success {
                    print(error?.localizedDescription)
                }
            }
        }
        
    }
    
    // MARK: Convenience
    
    /// Returns the `Activity` that matches the supplied `ActivityType`.
    func activityWithType(type: ActivityType) -> Activity? {
        for activity in activities where activity.activityType == type {
            return activity
        }
        
        return nil
    }
    
    func generateSampleDocument() -> OCKDocument {
        let subtitle = OCKDocumentElementSubtitle(subtitle: "First subtitle")
        
        let paragraph = OCKDocumentElementParagraph(content: "Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque.")
        
        let document = OCKDocument(title: "Sample Document Title", elements: [subtitle, paragraph])
        document.pageHeader = "App Name: Sue care plan, User Name: Sue Barker"
        
        return document
    }
}
