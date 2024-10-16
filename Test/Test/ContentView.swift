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
        return ContentView()
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
