import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Theme", destination: ThemeView())
                NavigationLink("Language", destination: LanguageView())
                NavigationLink("About", destination: AboutView())
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
