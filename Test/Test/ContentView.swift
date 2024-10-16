
import SwiftData
import SwiftUI

// 定义 ContentView 结构体，作为应用程序的根视图
struct ContentView: View {
    var body: some View {
        TabView {
            SoundsView()
                .tabItem {
                    Label("喵语", systemImage: "music.note")
                }

            CatsView()
                .tabItem {
                    Label("猫咪档案", systemImage: "pawprint")
                }
            
            CatsView()
                .tabItem {
                    Label("事项提醒", systemImage: "pawprint")
                }

            SettingView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
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
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
