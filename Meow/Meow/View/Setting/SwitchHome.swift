//
//  SwitchHome.swift
//  Test
//
//  Created by Actor on 2024/10/17.
//

import SwiftUI

struct SwitchHome: View {
    @StateObject private var languageManager = LanguageManager.shared
    @AppStorage("defaultTab") private var defaultTab = 0

    private enum Tab: Int, CaseIterable, Identifiable {
        case meow, accounting, reminder, settings
        
        var id: Int { rawValue }
        
        var title: String {
            switch self {
            case .meow: return "喵语"
            case .accounting: return "Weight Record"
            case .reminder: return "Event Reminder"
            case .settings: return "Settings"
            }
        }
    }

    var body: some View {
        VStack {
            Text("Set Home".localised(using: languageManager.selectedLanguage))
                .font(.headline)
            Picker("Set Home".localised(using: languageManager.selectedLanguage), selection: $defaultTab) {
                ForEach(Tab.allCases) { tab in
                    Text(tab.title.localised(using: languageManager.selectedLanguage)).tag(tab.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
}

#Preview {
    SwitchHome()
}
