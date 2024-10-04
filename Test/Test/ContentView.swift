import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            SoundsView()
                .tabItem {
                    Label("Sounds", systemImage: "music.note")
                }
            CatsView()
                .tabItem {
                    Label("Cats", systemImage: "pawprint")
                }
            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct CatsView: View {
    @Query private var cats: [Cat]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            List(cats) { cat in
                VStack(alignment: .leading) {
                    Text(cat.name)
                        .font(.headline)
                    Text("Age: \(cat.age)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Cats")
            .toolbar {
                Button("Add Cat") {
                    addCat()
                }
            }
        }
    }

    private func addCat() {
        let newCat = Cat(name: "New Cat", age: "1", desc: "A cute cat", gender: .unknown, bodyType: .medium)
        modelContext.insert(newCat)
    }
}

struct SettingView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }
                
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
