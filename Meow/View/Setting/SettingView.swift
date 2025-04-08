import SwiftUI

struct SettingView: View {
    @StateObject private var languageManager = LanguageManager.shared

    @State private var currentVersion = "1.0.0" // 默认版本号
    @State private var isNewVersionAvailable = false // 是否有新版本
    @State private var isCheckingVersion = false // 是否正在检查新版本
    @State private var isNotificationEnabled = true // 新增：通知开关状态
    
    var body: some View {
        NavigationStack {
            List {
                Section(header:Text("Data".localised(using: languageManager.selectedLanguage))) {
                    NavigationLink(destination: CatsView()) {
                        Text("Cat Profile".localised(using: languageManager.selectedLanguage))
                    }
                   
                    NavigationLink(destination: PetMedicalRecordView()) {
                        Text("Pet Medical Records".localised(using: languageManager.selectedLanguage))
                    }
                   
                }
                Section(header: Text("Features".localised(using: languageManager.selectedLanguage))) {
                      Toggle(isOn: $isNotificationEnabled) {
                        Text("Notifications".localised(using: languageManager.selectedLanguage))
                    }
                    NavigationLink(destination: ThemeView()) {
                        Text("Theme".localised(using: languageManager.selectedLanguage))
                    }
                    NavigationLink(destination: LanguageView()) {
                        Text("Language".localised(using: languageManager.selectedLanguage))
                    }
                    NavigationLink(destination: WeightUnitView()) {
                        Text("Weight Unit".localised(using: languageManager.selectedLanguage))
                    }
                    NavigationLink(destination: SwitchHome()) {
                        Text("Set Home".localised(using: languageManager.selectedLanguage))
                    } 
                }
               

                Section(header: Text("More".localised(using: languageManager.selectedLanguage))) {
                    NavigationLink(destination: AboutView()) {
                        Text("About".localised(using: languageManager.selectedLanguage))
                    }
                    versionCheckButton
                }
            }
            .navigationTitle(Text("Settings".localised(using: languageManager.selectedLanguage))).toolbarTitleDisplayMode(.inline)
        }
    }
    
    private var versionCheckButton: some View {
        Button(action: checkForNewVersion) {
            HStack {
                Text(String(format: "Check Version %@".localised(using: languageManager.selectedLanguage), currentVersion))
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
            Text("Up to date".localised(using: languageManager.selectedLanguage))
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
