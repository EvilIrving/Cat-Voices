//
//  AppState.swift
//  Test
//
//  Created by Actor on 2024/10/9.
//

import SwiftUI

class AppState: ObservableObject {
    @AppStorage("themeMode") var themeMode: ThemeMode = .system
}
