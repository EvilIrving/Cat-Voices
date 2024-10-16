import SwiftUI

struct SettingView: View {
    @State private var currentVersion = "1.0.0" // 默认版本号
    @State private var isNewVersionAvailable = false // 是否有新版本
    @State private var isCheckingVersion = false // 是否正在检查新版本
    
    var body: some View {
        NavigationStack {
            List {
                Section(header:Text("数据")) {
                    NavigationLink("猫猫档案", destination:  CatsView())
                   
                    NavigationLink("宠物病历", destination: PetMedicalRecordView())
                   
                }
                Section(header: Text("功能")) {
                    NavigationLink("主题", destination: ThemeView())
                    NavigationLink("多语言", destination: LanguageView())
                    NavigationLink("体重单位", destination: WeightUnitView())
                    NavigationLink("自定主页", destination: SwitchHome())
                }
               

                Section(header: Text("更多")) {
                     NavigationLink("关于我们", destination: AboutView())
                    // 版本显示
                    Button(action: {
                        checkForNewVersion()
                    }) {
                        HStack {
                            Text("检查版本 \(currentVersion)")
                                .foregroundColor(.primary)
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
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("设置").toolbarTitleDisplayMode(.inline)
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
        .environmentObject(AppState())
}
