//
//  SwitchHome.swift
//  Test
//
//  Created by Actor on 2024/10/17.
//

import SwiftUI

struct SwitchHome: View {
    @AppStorage("defaultTab") private var defaultTab = 0

    private enum Tab: Int, CaseIterable, Identifiable {
        case meow, accounting, reminder, settings
        
        var id: Int { rawValue }
        
        var title: String {
            switch self {
            case .meow: return "喵语"
            case .accounting: return "体重记录"
            case .reminder: return "事项提醒"
            case .settings: return "设置"
            }
        }
    }

    var body: some View {
        VStack {
            Text("选择默认主页")
                .font(.headline)
            Picker("选择主页", selection: $defaultTab) {
                ForEach(Tab.allCases) { tab in
                    Text(tab.title).tag(tab.rawValue)
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
