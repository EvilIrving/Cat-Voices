import SwiftData
import SwiftUI

struct NewEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var cats: [Cat]
    @State private var selectedEventType: Event.EventType = .bath
    @State private var selectedCat: Cat?
    @State private var reminderDate = Date()
    @State private var reminderTime = Date()
    @State private var repeatInterval = Event.RepeatInterval.daily
    @State private var notes = ""
    @State private var showingAddCustomTypeAlert = false
    @State private var customEventType: String = ""
    @State private var showingValidationAlert = false
    @State private var isSaveDisabled: Bool = true // 添加保存按钮禁用状态

    var body: some View {
        NavigationView {
            Form {
                Picker("事件类型", selection: $selectedEventType) {
                    ForEach(Event.EventType.allCases, id: \.self) { eventType in
                        Text(eventType.description).tag(eventType)
                    }
                    Text("添加自定义类型").tag(Event.EventType.custom("新增自定义类型"))
                }
                .onChange(of: selectedEventType) { oldValue, newValue in
                    print("事件类型从 \(oldValue) 变为 \(newValue)")
                    if case .custom("新增自定义类型") = newValue {
                        showingAddCustomTypeAlert = true
                        // 重置选择，以便用户可以再次选择"添加自定义类型"
                        selectedEventType = oldValue
                    }
                }

                Picker("选择猫咪", selection: $selectedCat) {
                    Text("请选择").tag(nil as Cat?)
                    ForEach(cats) { cat in
                        Text(cat.name).tag(cat as Cat?)
                    }
                }
                DatePicker("提醒日期", selection: $reminderDate, displayedComponents: .date)
                DatePicker("提醒时间", selection: $reminderTime, displayedComponents: .hourAndMinute)
                Picker("重复", selection: $repeatInterval) {
                    ForEach(Event.RepeatInterval.allCases, id: \.self) { interval in
                        Text(interval.description).tag(interval)
                    }
                }
                TextEditor(text: $notes)
                    .frame(height: 100)
            }
            .navigationTitle("新增提醒").toolbarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("取消") {
                dismiss()
            }, trailing: Button("保存") {
                saveEvent()
            }.disabled(isSaveDisabled)) // 禁用保存按钮
            .alert("校验失败", isPresented: $showingValidationAlert) {
                Text("请确保所有字段都已填写。")
                Button("确定", role: .cancel) {}
            }
            .alert("添加自定义类型", isPresented: $showingAddCustomTypeAlert) {
                TextField("输入自定义类型", text: $customEventType)
                Button("添加") {
                    if !customEventType.isEmpty {
                        Event.EventType.addCustomType(customEventType)
                        selectedEventType = .custom(customEventType)
                        customEventType = ""
                    }
                }
                Button("取消", role: .cancel) {}
            }
            .onChange(of: selectedCat) {
                isSaveDisabled = !validateEvent()
            }
            .onChange(of: notes) {
                isSaveDisabled = !validateEvent()
            }
        }
    }

    private func saveEvent() {
        guard validateEvent() else {
            showingValidationAlert = true // 显示校验失败警告
            return
        }
        guard let selectedCat = selectedCat else {
            // 处理未选择猫咪的情况,可能显示一个警告
            return
        }
        let newEvent = Event(eventType: selectedEventType, cat: selectedCat, reminderDate: reminderDate, reminderTime: reminderTime, repeatInterval: repeatInterval, notes: notes)

        modelContext.insert(newEvent!)
        dismiss()
    }

    private func addCustomEventType() {
        if !customEventType.isEmpty {
            Event.EventType.addCustomType(customEventType)
            selectedEventType = .custom(customEventType)
            customEventType = ""
        }
    }

    private func validateEvent() -> Bool {
        // 校验逻辑
        return selectedCat != nil // 确保猫咪选择不为空
    }
}
