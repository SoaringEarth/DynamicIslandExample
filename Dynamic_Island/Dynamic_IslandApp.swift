//
//  Dynamic_IslandApp.swift
//  Dynamic_Island
//
//  Created by Jonathon Albert on 29/09/2022.
//

import SwiftUI

@main
struct Dynamic_IslandApp: App {

    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.1, *) {
                ContentView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
