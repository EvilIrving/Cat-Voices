//
//  WeightsView.swift
//  Test
//
//  Created by Actor on 2024/10/17.
//

import SwiftData
import SwiftUI

struct WeightsView: View {
    @Query private var weights: [Weight]
    @AppStorage("weightUnit") private var weightUnit: String = "kg"

    var body: some View {
        NavigationView {
            List {
                ForEach(weights) { weight in
                    VStack(alignment: .leading) {
                        Text("体重: \(weight.formattedWeightInKg) \(weightUnit)")
                       HStack{
                        Text("\(weight.date, formatter: dateFormatter)")
                        Spacer()
                        Text("\(weight.cat.name)")
                       }
                    }
                    
                }
            }
            .navigationTitle("体重记录").toolbarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    // 打开添加体重记录的 sheet
                    // ... 这里是打开 sheet 的代码 ...
                }) {
                    Label("添加体重记录", systemImage: "plus")
                }
            }
        }
    }
}

// 日期格式化器
private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}

#Preview {
    WeightsView()
}
