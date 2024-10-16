import SwiftUI

struct LanguageView: View {
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
    
    // 使用 @AppStorage 绑定到 UserDefaults
    @AppStorage("selectedLanguage") var selectedLanguage: Language = Language.fromLocale()
    
    var body: some View {
        List {
            ForEach(Language.allCases, id: \.self) { language in
                Button(action: {
                    // 更新选择的语言
                    selectedLanguage = language
                }) {
                    HStack {
                        Text(language.rawValue).foregroundStyle(.black)
                        Spacer()
                        if selectedLanguage == language {
                            // 显示 checkmark 图标
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
//        .navigationTitle("Select Language")
    }
}

#Preview {
    LanguageView()
}
