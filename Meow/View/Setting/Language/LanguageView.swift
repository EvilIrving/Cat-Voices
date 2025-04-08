import SwiftUI

struct LanguageView: View {
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        VStack(spacing: 16) {
            List {
                ForEach(languageManager.supportedLanguages, id: \.self) { languageCode in
                    Button(action: {
                        languageManager.setLanguage(languageCode)
                    }) {
                        HStack {
                            Text(languageManager.languageDisplayName(for: languageCode))
                                .foregroundStyle(Color.accentColor)
                            Spacer()
                            if languageManager.selectedLanguage == languageCode {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }

            Text("Welcome".localised(using: languageManager.selectedLanguage))
        }
    }
}

#Preview {
    LanguageView()
}
