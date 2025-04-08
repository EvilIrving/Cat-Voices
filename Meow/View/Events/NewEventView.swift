import SwiftData
import SwiftUI

struct NewEventView: View {
    @StateObject private var languageManager = LanguageManager.shared

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var cats: [Cat]
    @StateObject private var viewModel = NewEventViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                eventTypePicker
                catPicker
                dateTimePickers
                repeatIntervalPicker
                notesEditor
            }
            .navigationTitle("Add Reminder".localised(using: languageManager.selectedLanguage)).toolbarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .alert("Validation Failed".localised(using: languageManager.selectedLanguage), isPresented: $viewModel.showingValidationAlert) {
                Text("Validation Filled".localised(using: languageManager.selectedLanguage))
                Button("Confirm".localised(using: languageManager.selectedLanguage), role: .cancel) {}
            }
            .alert("Add Custom Type".localised(using: languageManager.selectedLanguage), isPresented: $viewModel.showingAddCustomTypeAlert) {
                customTypeAlert
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel".localised(using: languageManager.selectedLanguage)) {
            dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("Save".localised(using: languageManager.selectedLanguage)) {
            viewModel.saveEvent(modelContext: modelContext, dismiss: dismiss)
        }
        .disabled(!viewModel.isFormValid)
    }
}

extension NewEventView {
    private var eventTypePicker: some View {
        Section(header: Text("Event Type".localised(using: languageManager.selectedLanguage))) {
            Picker("Select Event Type".localised(using: languageManager.selectedLanguage), selection: $viewModel.selectedEventType) {
                ForEach(Event.EventType.allCases, id: \.self) { type in
                    Text(type.description).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Button("Add Custom Type".localised(using: languageManager.selectedLanguage)) {
                viewModel.showingAddCustomTypeAlert = true
            }
        }
    }
    
    private var catPicker: some View {
        Section(header: Text("Select Cat".localised(using: languageManager.selectedLanguage))) {
            Picker("Select Cat".localised(using: languageManager.selectedLanguage), selection: $viewModel.selectedCat) {
                Text("Please Select".localised(using: languageManager.selectedLanguage)).tag(Cat?.none)
                ForEach(cats) { cat in
                    Text(cat.name).tag(Cat?.some(cat))
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    private var dateTimePickers: some View {
        Section(header: Text("Reminder Time".localised(using: languageManager.selectedLanguage))) {
            DatePicker("Date".localised(using: languageManager.selectedLanguage), selection: $viewModel.reminderDate, displayedComponents: .date)
            DatePicker("Time".localised(using: languageManager.selectedLanguage), selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
        }
    }
    
    private var repeatIntervalPicker: some View {
        Section(header: Text("Repeat Interval".localised(using: languageManager.selectedLanguage))) {
            Picker("Repeat Interval".localised(using: languageManager.selectedLanguage), selection: $viewModel.repeatInterval) {
                ForEach(Event.RepeatInterval.allCases, id: \.self) { interval in
                    Text(interval.description).tag(interval)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    private var notesEditor: some View {
        Section(header: Text("Notes".localised(using: languageManager.selectedLanguage))) {
            TextEditor(text: $viewModel.notes)
                .frame(height: 100)
        }
    }
    
    private var customTypeAlert: some View {
        VStack {
            TextField("Enter Custom Type".localised(using: languageManager.selectedLanguage), text: $viewModel.customEventType)
            Button("Add".localised(using: languageManager.selectedLanguage)) {
                viewModel.addCustomEventType()
            }
        }
    }
}

class NewEventViewModel: ObservableObject {
    @Published var selectedEventType: Event.EventType = .bath
    @Published var selectedCat: Cat? {
        didSet {
            checkFormValidity()
        }
    }
    @Published var reminderDate = Date()
    @Published var reminderTime = Date()
    @Published var repeatInterval = Event.RepeatInterval.daily
    @Published var notes = ""
    @Published var showingAddCustomTypeAlert = false
    @Published var customEventType: String = ""
    @Published var showingValidationAlert = false
    @Published var isFormValid: Bool = false
    
    private func checkFormValidity() {
        isFormValid = selectedCat != nil
    }
    
    func validateEvent() -> Bool {
        selectedCat != nil
    }
    
    func saveEvent(modelContext: ModelContext, dismiss: DismissAction) {
        guard isFormValid else {
            showingValidationAlert = true
            return
        }
        guard let selectedCat = selectedCat else { return }
        
        let newEvent = Event(eventType: selectedEventType,
                             cat: selectedCat,
                             reminderDate: reminderDate,
                             reminderTime: reminderTime,
                             repeatInterval: repeatInterval,
                             notes: notes)
        
        modelContext.insert(newEvent)
        dismiss()
    }
    
    func addCustomEventType() {
        if !customEventType.isEmpty {
            Event.EventType.addCustomType(customEventType)
            selectedEventType = .custom(customEventType)
            customEventType = ""
        }
    }
}
