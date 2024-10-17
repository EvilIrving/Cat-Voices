//
//  TestApp.swift
//  Test
//
//  Created by Actor on 2024/10/2.
//

import SwiftUI

@main
struct MeowApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(appState.themeMode.colorScheme)
        }
        .modelContainer(for: [Cat.self, Audio.self,Event.self])
    }
}
