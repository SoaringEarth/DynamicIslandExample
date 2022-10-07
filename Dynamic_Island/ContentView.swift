//
//  ContentView.swift
//  Dynamic_Island
//
//  Created by Jonathon Albert on 29/09/2022.
//

import SwiftUI
import ActivityKit

struct UserDefaultManager {

    static func saveNewActivity(id: String, status: String, deliveryDriverName: String, arrivalTime: String) {
        let activity = ["id": id, "status": status, "deliveryDriverName": deliveryDriverName, "arrivalTime": arrivalTime]
        if var activities: [[String: Any]] = UserDefaults.standard.object(forKey: "live_activities") as? [[String : String]] {
            activities.append(activity)
            UserDefaults.standard.set(activities, forKey: "live_activities")
        } else {
            UserDefaults.standard.set([activity], forKey: "live_activities")
        }
    }

    static func fetchActivities() -> [DeliveryAttributes.ContentState] {
        guard let activities: [[String: String]] = UserDefaults.standard.object(forKey: "live_activities") as? [[String : String]] else { return [] }
        return activities.compactMap({ DeliveryAttributes.ContentState(status: $0["status"] ?? "",
                                                                       deliveryDriverName: $0["deliveryDriverName"] ?? "",
                                                                       arrivalTime: $0["arrivalTime"] ?? "") })
    }
}

@available(iOS 16.1, *)
struct ContentView: View {

    @State var status: String = ""
    @State var driverName: String = ""
    @State var expectedDeliveryTime: String = ""

    @State var activities = [DeliveryAttributes.ContentState]()

    var body: some View {
        VStack {
            List {
                ForEach(activities, id: \.self) { item in
                    Text(item.status)
                        .onTapGesture {
                            if let activeActivity = Activity<DeliveryAttributes>.activities.first(where: { $0.contentState.deliveryDriverName == item.deliveryDriverName && $0.contentState.status == item.status }) {
                                Task {
                                    await LiveActivityManager.endActivity(activeActivity.id)
                                }
                            } else {
                                do {
                                    try LiveActivityManager.startActivity(status: item.status, driverName: item.deliveryDriverName, expectingDeliveryTime: item.arrivalTime)
                                } catch {
                                    print(error)
                                }

                            }
                        }
                }
                .onDelete { index in
                    print(index)
                    print(activities)
                    activities = UserDefaultManager.fetchActivities()
                }
            }
            Spacer()
            Text("Create New Activity")

            TextField("Status", text: $status)
                .frame(height: 32)
                .padding(.horizontal, 8.0)
                .border(.blue, width: 2.0)
            TextField("Driver Name", text: $driverName)
                .frame(height: 32)
                .padding(.horizontal, 8.0)
                .border(.blue, width: 2.0)
            TextField("Expected Delivery Time", text: $expectedDeliveryTime)
                .frame(height: 32)
                .padding(.horizontal, 8.0)
                .border(.blue, width: 2.0)

            Button("Submit") {
                do {
                    let id = try LiveActivityManager.startActivity(status: status,
                                                                   driverName: driverName,
                                                                   expectingDeliveryTime: expectedDeliveryTime)
                    UserDefaultManager.saveNewActivity(id: id,
                                                       status: status,
                                                       deliveryDriverName: driverName,
                                                       arrivalTime: expectedDeliveryTime)
                    activities = UserDefaultManager.fetchActivities()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .padding()
        .onAppear {
            activities = UserDefaultManager.fetchActivities()
            print(activities)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.1, *) {
            ContentView()
        } else {
            // Fallback on earlier versions
        }
    }
}
