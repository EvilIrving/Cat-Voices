import SwiftUI

struct SettingView: View {
    @State private var currentVersion = "1.0.0" // 默认版本号
    @State private var isNewVersionAvailable = false // 是否有新版本
    @State private var isCheckingVersion = false // 是否正在检查新版本
    @State private var isNotificationEnabled = true // 新增：通知开关状态
    
    var body: some View {
        NavigationStack {
            List {
                Section(header:Text("Data")) {
                    NavigationLink(destination: CatsView()) {
                        
                        LocalizedText(key: "Cats")
                    }
                   
                    NavigationLink(destination: PetMedicalRecordView()) {
                        LocalizedText(key: "Pet Medical Record")
                    }
                   
                }
                Section(header: Text("Function")) {
                      Toggle(isOn: $isNotificationEnabled) {
                        LocalizedText(key: "Message Notification")
                    }
                    NavigationLink(destination: ThemeView()) {
                        LocalizedText(key: "Theme")
                    }
                    NavigationLink(destination: LanguageView()) {
                        LocalizedText(key: "Languages")
                    }
                    NavigationLink(destination: WeightUnitView()) {
                        LocalizedText(key: "Weight Unit")
                    }
                    NavigationLink(destination: SwitchHome()) {
                        LocalizedText(key: "Switch Home")
                    } 
                }
               

                Section(header: Text("More")) {
                    NavigationLink(destination: AboutView()) {
                        LocalizedText(key: "About")
                    }
                    versionCheckButton
                }
            }
            .navigationTitle(Text("Settings")).toolbarTitleDisplayMode(.inline)
        }
    }
    
    private var versionCheckButton: some View {
        Button(action: checkForNewVersion) {
            HStack {
                LocalizedText(key: "Check Version \(currentVersion)")
                    .foregroundColor(.primary)
                Spacer()
                versionStatusView
            }
        }
    }
    
    @ViewBuilder
    private var versionStatusView: some View {
        if isCheckingVersion {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        } else if isNewVersionAvailable {
            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
        } else {
            LocalizedText(key: "Up to date")
                .font(.footnote)
                .foregroundColor(.secondary)
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
