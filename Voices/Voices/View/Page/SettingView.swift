import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("language") private var language = "中文"
    @State private var showAbout = false
    
    var body: some View {
        NavigationView {
            Form {
                // 主题选择
                Toggle(isOn: $isDarkMode) {
                    Text("主题")
                }
                .onChange(of: isDarkMode) {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        for window in windowScene.windows {
                            window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }
                    }
                }
                
                // 语言选择
                Picker("语言", selection: $language) {
                    Text("中文").tag("中文")
                    Text("英文").tag("英文")
                    Text("日文").tag("日文")
                }
                
                // 关于
                Button("关于") {
                    showAbout = true
                }
                .sheet(isPresented: $showAbout) {
                    AboutView()
                }
            }
            .navigationTitle(Text("设置").font(.headline)) // 设置标题大小
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("取消") {
                dismiss()
            }.font(.headline)) // 设置取消按钮字体大小
        }
    }
}
