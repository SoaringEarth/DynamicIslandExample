//
//  LiveActivity.swift
//  Dynamic_Island
//
//  Created by Jonathon Albert on 29/09/2022.
//

import Foundation
import ActivityKit

enum LiveActivityManagerError: Error {
    case failedToGetId
}

@available(iOS 16.1, *)
class LiveActivityManager {

    @discardableResult
    static func startActivity(status: String, driverName: String, expectingDeliveryTime: String) throws -> String {
        var activity: Activity<DeliveryAttributes>?
        let initialState = DeliveryAttributes.ContentState(status: status,
                                                           deliveryDriverName: driverName,
                                                           arrivalTime: expectingDeliveryTime)
        do {
            activity = try Activity.request(attributes: DeliveryAttributes(),
                                            contentState: initialState,
                                            pushType: nil)
            guard let id = activity?.id else { throw LiveActivityManagerError.failedToGetId }
            return id
        } catch {
            throw error
        }
    }

    static func listAllActivities() -> [[String: String]] {
        let sortedActivities = Activity<DeliveryAttributes>.activities.sorted { $0.id > $1.id }
        return sortedActivities.map {
            ["id": $0.id,
             "status": $0.contentState.status,
             "deliveryDriverName": $0.contentState.deliveryDriverName,
             "arrivalTime": $0.contentState.arrivalTime]
        }
    }

    static func endAllActivities() async {
        for activity in Activity<DeliveryAttributes>.activities {
            await activity.end(dismissalPolicy: .immediate)
        }
    }

    static func endActivity(_ id: String) async {
        await Activity<DeliveryAttributes>.activities.first(where: { $0.id == id })?.end(dismissalPolicy: .immediate)
    }

    static func updateActivity(id: String, status: String, deliveryDriverName: String, arrivalTime: String) async {
        let updatedContentState = DeliveryAttributes.ContentState(status: status,
                                                                  deliveryDriverName: deliveryDriverName,
                                                                  arrivalTime: arrivalTime)
        let activity = Activity<DeliveryAttributes>.activities.first(where: { $0.id == id })
        await activity?.update(using: updatedContentState)
    }
}
