import SwiftUI
import SwiftData

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
            .navigationTitle("新增提醒")
            .navigationBarItems(leading: Button("取消") {
                dismiss()
            }, trailing: Button("保存") {
                saveEvent()
            })
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
        }
    }
    
    private func saveEvent() {
        guard let selectedCat = selectedCat else {
            // 处理未选择猫咪的情况,可能显示一个警告
            return
        }
        let newEvent = Event(eventType: selectedEventType, cat: selectedCat, reminderDate: reminderDate, reminderTime: reminderTime, repeatInterval: repeatInterval, notes: notes)
        modelContext.insert(newEvent)
        dismiss()
    }
    
    private func addCustomEventType() {
        if !customEventType.isEmpty {
            Event.EventType.addCustomType(customEventType)
            selectedEventType = .custom(customEventType)
            customEventType = ""
        }
    }
}
