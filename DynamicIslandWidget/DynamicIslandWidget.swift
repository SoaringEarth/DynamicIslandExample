//
//  DynamicIslandWidget.swift
//  DynamicIslandWidget
//
//  Created by Jonathon Albert on 29/09/2022.
//

import WidgetKit
import SwiftUI

@main
@available(iOS 16.1, *)
struct LiveActivityDynamicIsland: Widget {

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            HStack {
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    .foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text(context.state.deliveryDriverName + " is")
                    Text(context.state.status)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Expected Delivery")
                    Text(context.state.arrivalTime)
                }
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                        .resizable()
                        .frame(width: 44.0, height: 44.0)
                        .foregroundColor(.green)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text("by " + context.state.arrivalTime)
                    }
                    .padding(.top, 16.0)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.deliveryDriverName + " is " + context.state.status.lowercased() + " your order")
                }
            } compactLeading: {
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    .foregroundColor(.green)
            } compactTrailing: {
                Text("on route")
            } minimal: {
                Image(systemName: "takeoutbag.and.cup.and.straw")
                    .foregroundColor(.green)
            }
        }
    }
}
