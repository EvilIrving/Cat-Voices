import SwiftData
import SwiftUI

struct NewEventView: View {
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
            .navigationTitle("新增提醒").toolbarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .alert("校验失败", isPresented: $viewModel.showingValidationAlert) {
                Text("请确保所有字段都已填写。")
                Button("确定", role: .cancel) {}
            }
            .alert("添加自定义类型", isPresented: $viewModel.showingAddCustomTypeAlert) {
                customTypeAlert
            }
        }
    }
    
    private var cancelButton: some View {
        Button("取消") {
            dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("保存") {
            viewModel.saveEvent(modelContext: modelContext, dismiss: dismiss)
        }
        .disabled(!viewModel.isFormValid)
    }
}

extension NewEventView {
    private var eventTypePicker: some View {
        Section(header: Text("事件类型")) {
            Picker("选择事件类型", selection: $viewModel.selectedEventType) {
                ForEach(Event.EventType.allCases, id: \.self) { type in
                    Text(type.description).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Button("添加自定义类型") {
                viewModel.showingAddCustomTypeAlert = true
            }
        }
    }
    
    private var catPicker: some View {
        Section(header: Text("选择猫咪")) {
            Picker("选择猫咪", selection: $viewModel.selectedCat) {
                Text("请选择").tag(Cat?.none)
                ForEach(cats) { cat in
                    Text(cat.name).tag(Cat?.some(cat))
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    private var dateTimePickers: some View {
        Section(header: Text("提醒时间")) {
            DatePicker("日期", selection: $viewModel.reminderDate, displayedComponents: .date)
            DatePicker("时间", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
        }
    }
    
    private var repeatIntervalPicker: some View {
        Section(header: Text("重复间隔")) {
            Picker("重复间隔", selection: $viewModel.repeatInterval) {
                ForEach(Event.RepeatInterval.allCases, id: \.self) { interval in
                    Text(interval.description).tag(interval)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
    
    private var notesEditor: some View {
        Section(header: Text("备注")) {
            TextEditor(text: $viewModel.notes)
                .frame(height: 100)
        }
    }
    
    private var customTypeAlert: some View {
        VStack {
            TextField("输入自定义类型", text: $viewModel.customEventType)
            Button("添加") {
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
