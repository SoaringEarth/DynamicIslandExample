//
//  LiveActivityAttributes.swift
//  Dynamic_Island
//
//  Created by Jonathon Albert on 29/09/2022.
//

import Foundation
import ActivityKit

struct DeliveryAttributes: ActivityAttributes {

    public struct ContentState: Codable, Hashable {
        var status: String
        var deliveryDriverName: String
        var arrivalTime: String
    }
}
