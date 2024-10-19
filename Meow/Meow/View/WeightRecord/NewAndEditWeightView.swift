//
//  WeightRecordView.swift
//  Test
//
//  Created by Actor on 2024/10/17.
//

import SwiftData
import SwiftUI

struct NewAndEditWeightView: View {
    @StateObject private var languageManager = LanguageManager.shared
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
                DatePicker("Date".localised(using: languageManager.selectedLanguage), selection: $weightDate, displayedComponents: .date)
                weightInput
            }
            .onAppear(perform: validateInitialState)
            .navigationTitle(weightToEdit == nil ? "Record Weight".localised(using: languageManager.selectedLanguage) : "Edit Weight".localised(using: languageManager.selectedLanguage)).toolbarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel".localised(using: languageManager.selectedLanguage)) {
                    dismiss()
                },
                trailing: Button("Save".localised(using: languageManager.selectedLanguage)) {
                    saveWeightRecord()
                }
                .disabled(!isFormValid)
            )
            .alert("Please add a cat first".localised(using: languageManager.selectedLanguage), isPresented: $showNoCatsAlert) {
                Button("OK".localised(using: languageManager.selectedLanguage)) {
                    dismiss()
                }
            } message: {
                Text("Please add at least one cat in the cat list.".localised(using: languageManager.selectedLanguage))
            }
        }
    }

    private var catPicker: some View {
        Picker("Select Cat".localised(using: languageManager.selectedLanguage), selection: $selectedCat) {
            ForEach(cats) { cat in
                Text(cat.name.localised(using: languageManager.selectedLanguage)).tag(cat as Cat?)
            }
        }
    }

    private var weightInput: some View {
        CustomInputField(
            label: "Weight",
            placeholder: "Please enter weight",
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
