//
//  OCKInsightItem+EmptyMessage.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import CareKit

extension OCKInsightItem {
    /// Returns an `OCKInsightItem` to show when no insights have been calculated.
    static func emptyInsightsMessage() -> OCKInsightItem {
        return OCKMessageItem(title: "No Insights", text: "Soz, there are no insights to show.", tintColor: Colors.Green.color, messageType: .Tip)
    }
}
