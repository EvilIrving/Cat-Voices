//
//  CatsApp.swift
//  Cats
//
//  Created by Actor on 2024/9/27.
//

import SwiftUI
import SwiftData

@main
struct CatsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Cat.self)
    }
}
