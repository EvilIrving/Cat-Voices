//
//  WeightUnitView.swift
//  Test
//
//  Created by Actor on 2024/10/17.
//

import SwiftUI

struct WeightUnitView: View {
    @AppStorage("weightUnit") private var weightUnit: String = "kg" // 用于跟踪选中的单位，默认值为 kg

    var body: some View {
        List {
            ForEach(["kg", "g", "斤"], id: \.self) { unit in
                HStack {
                    Text(unit)
                    Spacer()
                    if weightUnit == unit {
                        Image(systemName: "checkmark").foregroundColor(.accentColor)// 显示选中图标
                    }
                }
                .contentShape(Rectangle()) // 确保整个区域都可以响应点击
                .onTapGesture {
                    weightUnit = unit // 更新选中状态
                }
            }
        }
    }
}

#Preview {
    WeightUnitView()
}
