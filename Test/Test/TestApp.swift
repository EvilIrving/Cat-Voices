//
//  TestApp.swift
//  Test
//
//  Created by Actor on 2024/10/2.
//

import SwiftUI

@main
struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Cat.self, Audio.self])
    }
}
