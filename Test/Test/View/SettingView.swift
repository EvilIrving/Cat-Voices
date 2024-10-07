import SwiftUI

struct SettingView: View {
    @State private var currentVersion = "1.0.0" // 默认版本号
    @State private var isNewVersionAvailable = false // 是否有新版本
    @State private var isCheckingVersion = false // 是否正在检查新版本
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Theme", destination: ThemeView())
                NavigationLink("Language", destination: LanguageView())
                NavigationLink("About", destination: AboutView())
                
                // 版本显示
                Button(action: {
                    checkForNewVersion()
                }) {
                    HStack {
                        Text("Version \(currentVersion)").foregroundStyle(.black)
                        Spacer()
                        if isCheckingVersion {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else if isNewVersionAvailable {
                            // 如果有新版本，显示小红点
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                        } else {
                            Text("当前是最新版本")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    // 模拟检查新版本的逻辑
    func checkForNewVersion() {
        isCheckingVersion = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // 模拟版本检查结果
            let availableVersion = "1.1.0"
            
            if availableVersion > currentVersion {
                isNewVersionAvailable = true
            } else {
                isNewVersionAvailable = false
            }
            isCheckingVersion = false
        }
    }
}


#Preview {
    SettingView()
}
