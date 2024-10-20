import SwiftData
import SwiftUI

// 定义标签页枚举
enum Tab: Int, CaseIterable {
    
    case sounds, weights, events, settings
    
    var label: (String, String) {
        switch self {
        case .sounds: return ("Sounds", "music.note")
        case .weights: return ("Weights", "chart.bar")
        case .events: return ("Reminder", "calendar")
        case .settings: return ("Settings", "gear")
        }
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .sounds: SoundsView()
        case .weights: WeightsView()
        case .events: EventsView()
        case .settings: SettingView()
        }
    }
}

struct ContentView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @State private var selectedTab: Tab = .sounds
    @AppStorage("defaultTab") private var defaultTab: Tab.RawValue = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.view()
                    .tabItem {
                        Label(tab.label.0.localised(using: languageManager.selectedLanguage), systemImage: tab.label.1)
                    }
                    .tag(tab)
            }
        }
        .onAppear {
            selectedTab = Tab(rawValue: defaultTab) ?? .sounds
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
