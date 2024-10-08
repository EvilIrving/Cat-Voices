//
//  ThemeView.swift
//  Test
//
//  Created by Actor on 2024/10/8.
//

import SwiftUI

enum ThemeMode: String, CaseIterable, Identifiable {
    case system, light, dark
    
    var id: Self { self }
    
    var displayName: String {
        switch self {
        case .system: return "跟随系统"
        case .light: return "浅色模式"
        case .dark: return "深色模式"
        }
    }
    
    // 添加获取对应颜色的方法
    var colorScheme: ColorScheme {
        switch self {
        case .system: return .init(.unspecified) ?? .light // 使用系统的颜色
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct ThemeView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.colorScheme) private var systemColorScheme
    
    var body: some View {
        List {
            ForEach(ThemeMode.allCases) { mode in
                Button(action: {
                    appState.themeMode = mode
                }) {
                    HStack {
                        Text(mode.displayName).foregroundColor(.primary)
                        Spacer()
                        if appState.themeMode == mode {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
//        .navigationTitle("主题设置")
        .onAppear {
            if appState.themeMode == .system {
                print("当前系统模式: \(systemColorScheme == .dark ? "深色" : "浅色")")
            }
        }
    }
}

#Preview {
    NavigationView {
        ThemeView()
            .environmentObject(AppState())
    }
}
