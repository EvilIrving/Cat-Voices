import SwiftUI

struct LanguageView: View {
    @State private var selectedLanguage: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
    
    var body: some View {
        List {
            Button(action: {
                setLanguage("English")
            }) {
                HStack {
                    Text("English")
                    Spacer()
                    if selectedLanguage == "English" {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button(action: {
                setLanguage("中文")
            }) {
                HStack {
                    Text("中文")
                    Spacer()
                    if selectedLanguage == "中文" {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button(action: {
                setLanguage("日本語")
            }) {
                HStack {
                    Text("日本語")
                    Spacer()
                    if selectedLanguage == "日本語" {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .navigationTitle("Select Language")
    }
    
    func setLanguage(_ language: String) {
        selectedLanguage = language
        UserDefaults.standard.set(language, forKey: "selectedLanguage")
    }
}

struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView()
    }
}
