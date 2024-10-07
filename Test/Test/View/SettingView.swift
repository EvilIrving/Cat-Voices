//
//  SettingView.swift
//  Test
//
//  Created by Actor on 2024/10/7.
//

import SwiftUI

// 定义 SettingView 结构体，用于显示设置页面
struct SettingView: View {
    // 使用 @State 注解，声明 notificationsEnabled 和 darkModeEnabled 属性，用于控制通知和暗黑模式
   
    @State private var darkModeEnabled = false

    var body: some View {
        NavigationView {
            Form {
               
                // 添加外观设置部分
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }

                // 添加关于部分
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
