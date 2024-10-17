//
//  WeightRecordView.swift
//  Test
//
//  Created by Actor on 2024/10/17.
//

import SwiftData
import SwiftUI

struct NewAndEditWeightView: View {
    @AppStorage("weightUnit") private var weightUnit: String = "kg"
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var cats: [Cat]

    @State private var selectedCat: Cat?
    @State private var weightDate: Date = Date()
    @State private var weightInKg: Double?

    private let weightToEdit: Weight?
    @State private var showNoCatsAlert: Bool = false

    init(weightToEdit: Weight? = nil) {
        self.weightToEdit = weightToEdit
        _weightDate = State(initialValue: weightToEdit?.date ?? Date())
        _weightInKg = State(initialValue: weightToEdit?.weightInKg)
        _selectedCat = State(initialValue: weightToEdit?.cat)
    }

    var body: some View {
        NavigationView {
            Form {
                catPicker
                DatePicker("日期", selection: $weightDate, displayedComponents: .date)
                weightInput
            }
            .onAppear(perform: validateInitialState)
            .navigationTitle(weightToEdit == nil ? "记录体重" : "编辑体重").toolbarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    saveWeightRecord()
                }
                .disabled(!isFormValid)
            )
            .alert("请先添加猫咪", isPresented: $showNoCatsAlert) {
                Button("确定") {
                    dismiss()
                }
            } message: {
                Text("请先在猫咪列表中添加至少一只猫咪。")
            }
        }
    }

    private var catPicker: some View {
        Picker("选择猫咪", selection: $selectedCat) {
            ForEach(cats) { cat in
                Text(cat.name).tag(cat as Cat?)
            }
        }
    }

    private var weightInput: some View {
        CustomInputField(
            label: "体重",
            placeholder: "请输入体重",
            suffix: "kg",
            value: $weightInKg
        )
    }

    private var isFormValid: Bool {
        selectedCat != nil && weightInKg != nil && weightInKg! > 0
    }

    private func validateInitialState() {
        if cats.isEmpty {
            showNoCatsAlert = true
        } else if selectedCat == nil {
            selectedCat = cats.first
        }
    }

    private func saveWeightRecord() {
        guard let cat = selectedCat, let weight = weightInKg else { return }

        if let existingWeight = weightToEdit {
            existingWeight.date = weightDate
            existingWeight.cat = cat
            existingWeight.weightInKg = weight
        } else {
            let newWeight = Weight(date: weightDate, cat: cat, weightInKg: weight)
            modelContext.insert(newWeight)
        }

        try? modelContext.save()
        dismiss()
    }
}
