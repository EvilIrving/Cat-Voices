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
    @State private var isPresentingNewWeightView = false // 新增状态变量
    // 需要编辑的体重
    @State private var weightToEdit: Weight?
    var body: some View {
        NavigationView {
            List {
                ForEach(weights) { weight in
                    VStack(alignment: .leading) {
                        Text("体重: \(weight.formattedWeightInKg) \(weightUnit)")
                        HStack {
                            Text("\(weight.date, formatter: dateFormatter)")
                            Spacer()
                            Text("\(weight.cat.name)")

                            Spacer()

                            Image(systemName: "square.and.pencil.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                                .onTapGesture {
                                    weightToEdit = weight
                                    isPresentingNewWeightView = true
                                }
                        }
                    }
                }
            }
            .navigationTitle("体重记录").toolbarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    isPresentingNewWeightView = true // 打开新增体重记录的 sheet
                }) {
                    Label("添加体重记录", systemImage: "plus")
                }
            }
            .sheet(isPresented: $isPresentingNewWeightView) {
                NewAndEditWeightView(weightToEdit: weightToEdit)
                // .onDisappear {
                //     weightToEdit = nil // 重置编辑状态
                // }
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
