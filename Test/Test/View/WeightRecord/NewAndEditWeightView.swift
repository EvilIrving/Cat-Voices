//
//  WeightRecordView.swift
//  Test
//
//  Created by Actor on 2024/10/17.
//

import SwiftData
import SwiftUI

struct NewAndEditWeightView: View {
    @AppStorage("weightUnit") private var weightUnit: String = "kg" // 只从 AppStorage 读取，不修改
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var cats: [Cat]

    @State private var selectedCat: Cat?
    @State private var weightDate: Date = Date()
    @State private var weightInKg: Double?

    @State private var weightToEdit: Weight?
    @State private var validateSave: Bool = false

    init(weightToEdit: Weight? = nil) {
        self.weightToEdit = weightToEdit
        _weightDate = State(initialValue: weightToEdit?.date ?? Date())
        _weightInKg = State(initialValue: weightToEdit?.weightInKg)
        _selectedCat = State(initialValue: weightToEdit?.cat)
    }

    var body: some View {
        NavigationView{
            Form {
            Picker("选择猫咪", selection: $selectedCat) {
                // 假设有一个 cats 数组可供选择
                ForEach(cats) { cat in
                    Text(cat.name).tag(cat as Cat?)
                }
            }

            DatePicker("日期", selection: $weightDate, displayedComponents: .date)

            CustomInputField(
                label: "体重",
                placeholder: "请输入体重",
                suffix: "kg",
                value: $weightInKg
            )

//
//                HStack {
//                    Text("体重") // Label
//                    TextField("请输入体重", value: $weightInKg, formatter: NumberFormatter())
//                        .keyboardType(.decimalPad) // 允许 有一个 占位符
//                        .multilineTextAlignment(.trailing) // 文字靠右对齐
//
//                    Text(weightUnit) // 显示单位后缀
//                }
        }
        }
        .navigationTitle(weightToEdit == nil ? "记录体重" : "编辑体重")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("取消") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    saveWeightRecord()
                }.disabled(validateSave)
            }
        }
    }

    private func saveWeightRecord() {
        guard let cat = selectedCat, let weight = weightInKg else {
            // 处理未选择猫咪或未输入体重的情况
            validateSave = true
            return
        }

        if let existingWeight = weightToEdit {
            // 更新现有记录
            existingWeight.date = weightDate
            existingWeight.cat = cat
            existingWeight.weightInKg = weight
        } else {
            // 创建新记录
            let newWeight = Weight(date: weightDate, cat: cat, weightInKg: weight)
            modelContext.insert(newWeight)
        }

        // 保存更改并关闭视图
        try? modelContext.save()
        dismiss()
    }
}