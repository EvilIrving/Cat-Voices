//
//  SwitchHome.swift
//  Test
//
//  Created by Actor on 2024/10/17.
//

import SwiftUI

struct SwitchHome: View {
    @AppStorage("defaultTab") private var defaultTab = 0 // 新增：存储默认标签

    var body: some View {
        VStack {
            Text("选择默认主页")
                .font(.headline)
            Picker("选择主页", selection: $defaultTab) {
                Text("喵语").tag(0)
                Text("记账").tag(1)
                Text("事项提醒").tag(2)
                Text("设置").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
}

// 预览代码
#Preview {
    SwitchHome()
}
