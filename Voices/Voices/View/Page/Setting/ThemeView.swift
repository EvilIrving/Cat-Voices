import SwiftUI

struct ThemeView: View {
    @State private var selectedTheme: String = UserDefaults.standard.string(forKey: "selectedTheme") ?? "Light"
    
    var body: some View {
        List {
            Button(action: {
                setTheme("Light")
            }) {
                HStack {
                    Text("Light")
                    Spacer()
                    if selectedTheme == "Light" {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button(action: {
                setTheme("Dark")
            }) {
                HStack {
                    Text("Dark")
                    Spacer()
                    if selectedTheme == "Dark" {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .navigationTitle("Select Theme")
    }
    
    func setTheme(_ theme: String) {
        selectedTheme = theme
        UserDefaults.standard.set(theme, forKey: "selectedTheme")
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView()
    }
}
