import SwiftUI

struct LanguageView: View {
    @StateObject private var languageManager = LanguageManager.shared
//    @State private var showRestartAlert = false
    
    // 支持的语言枚举
    enum Language: String, CaseIterable {
        case english = "English"
        case japanese = "日本語"
        case chinese = "中文"
        case traditionalChinese = "繁體中文" // 添加繁体中文选项

        static func fromLocale() -> Language {
            let systemLanguage = Locale.current.language.languageCode?.identifier
            switch systemLanguage {
            case "zh-Hant": return .traditionalChinese // 处理繁体中文
            case "zh": return .chinese
            case "ja": return .japanese
            default: return .english
            }
        } 
    }

    var body: some View {
        VStack(spacing: 16) {
            List {
                ForEach(Language.allCases, id: \.self) { language in
                    Button(action: {
                        languageManager.currentLanguage = language
                    }) {
                        HStack {
                            LocalizedText(key: LocalizedStringKey(language.rawValue))
                                .foregroundStyle(Color.accentColor)
                            Spacer()
                            if languageManager.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }

            Text("Welcome".localized(using:languageManager.currentLanguage?.identifier ?? "en"))
        //    LocalizedText(key: "Welcome")
        }
//        .onChange(of: languageManager.currentLanguage) {
//            showRestartAlert = true
//        }
//        .alert(isPresented: $showRestartAlert) {
//            Alert(
//                title: Text("Restart Required"),
//                message: Text("Please restart the app for the language change to take effect."),
//                dismissButton: .default(Text("OK"))
//            )
//        }
    }
}

#Preview {
    LanguageView()
        .environment(\.locale, .init(identifier: "en"))
}
