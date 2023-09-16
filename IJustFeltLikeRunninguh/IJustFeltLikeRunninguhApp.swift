//
//  IJustFeltLikeRunninguhApp.swift
//  IJustFeltLikeRunninguh
//
//  Created by Phillip Williams on 9/15/23.
//

import SwiftData
import SwiftUI

@main
struct IJustFeltLikeRunninguhApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    Run.self,
                ])
        }
    }
}
