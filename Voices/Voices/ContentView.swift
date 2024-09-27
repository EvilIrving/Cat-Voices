//
//  ContentView.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

import AVFoundation
import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            SoundsView()
                .tabItem {
                    Label("Sounds", systemImage: "music.note")
                }
            CatsView()
                .tabItem {
                    Label("Cats", systemImage: "pawprint")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
//
//#Preview {
//    ContentView()
//}
