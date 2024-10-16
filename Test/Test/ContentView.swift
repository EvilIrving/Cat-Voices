import SwiftData
import SwiftUI

// 定义 ContentView 结构体，作为应用程序的根视图
struct ContentView: View {
    @State private var selectedTab = 2

    var body: some View {
        TabView(selection: $selectedTab) {
            SoundsView()
                .tabItem {
                    Label("喵语", systemImage: "music.note")
                }
                .tag(0)
            
            CatsView()
                .tabItem {
                    Label("猫咪档案", systemImage: "pawprint")
                }
                .tag(1)
            
            EventsView()
                .tabItem {
                    Label("事项提醒", systemImage: "calendar")
                }
                .tag(2)
            
            SettingView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
                .tag(3)
        }
    }
} 


// 预览代码
#Preview {
    do {
        let previewer = try Previewer()
        let modelContext = previewer.container.mainContext
        
        // 创建一只默认猫咪
        let defaultCat = Cat(name: "咪咪", breed: .britishShorthair, gender: .female, neuteringStatus: .neutered, currentStatus: .present)
        modelContext.insert(defaultCat)
        
        // 创建一些默认的事件
        let event1 = Event(eventType: .bath, cat: defaultCat, reminderDate: Date().addingTimeInterval(86400), reminderTime: Date(), repeatInterval: .weekly, notes: "使用猫咪专用洗发水")
        let event2 = Event(eventType: .doctorVisit, cat: defaultCat, reminderDate: Date().addingTimeInterval(7 * 86400), reminderTime: Date(), repeatInterval: .monthly, notes: "带上疫苗本")
        let event3 = Event(eventType: .feeding, cat: defaultCat, reminderDate: Date().addingTimeInterval(3 * 86400), reminderTime: Date(), repeatInterval: .daily, notes: "使用新购买的猫粮")
        
        // 将事件添加到数据库
        modelContext.insert(event1)
        modelContext.insert(event2)
        modelContext.insert(event3)
        
        return EventsView()
            .modelContainer(previewer.container)
            .environmentObject(AppState())
    } catch {
        return Text("预览创建失败: \(error.localizedDescription)")
    }
}

// EventsView 的预览代码
#Preview {
    do {
        let previewer = try Previewer()
        return EventsView()
            .modelContainer(previewer.container)
            .environmentObject(AppState())
    } catch {
        return Text("预览创建失败: \(error.localizedDescription)")
    }
}
