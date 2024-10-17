import SwiftData
import SwiftUI

// 定义 ContentView 结构体，作为应用程序的根视图
struct ContentView: View {
    @State private var selectedTab = 0
    @AppStorage("defaultTab") private var defaultTab = 0 // 新增：存储默认标签

    var body: some View {
        TabView(selection: $selectedTab) {
            SoundsView()
                .tabItem {
                    Label("喵语", systemImage: "music.note")
                }
                .tag(0)

            // // 补充记账页面
            // FinanceView()
            //     .tabItem {
            //         Label("记账", systemImage: "banknote")
            //     }
            //     .tag(1)

            WeightsView()
                .tabItem {
                    Label("体重记录", systemImage: "chart.bar")
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
        .onAppear {
            selectedTab = defaultTab // 新增：在视图出现时设置选中的标签
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
// #Preview {
//    do {
//        let previewer = try Previewer()
//        return EventsView()
//            .modelContainer(previewer.container)
//            .environmentObject(AppState())
//    } catch {
//        return Text("预览创建失败: \(error.localizedDescription)")
//    }
// }
