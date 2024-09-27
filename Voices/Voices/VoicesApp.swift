//
//  VoicesApp.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

import SwiftUI
import SwiftData

@main
struct VoicesApp: App {
    var body: some Scene {
        WindowGroup {
            CatsView()
                .modelContainer(for: Cat.self)
        }
    }
}
