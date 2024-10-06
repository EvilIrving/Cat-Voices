import Foundation
import SwiftData
import SwiftUI

@Model
final class Cat {
    @Attribute(.unique) let id: UUID
    var name: String
    var age: String
    var desc: String
    var avatar: URL?
    var nickname: String?
    var gender: Gender
    var birthday: Date?
    var weight: Double?
    var bodyType: BodyType
    @Relationship(deleteRule: .cascade) var audios: [Audio] = []

    init(id: UUID = UUID(), name: String, age: String, desc: String, gender: Gender, bodyType: BodyType) {
        self.id = id
        self.name = name
        self.age = age
        self.desc = desc
        self.gender = gender
        self.bodyType = bodyType
    }
}

enum Gender: String, Codable {
    case male, female, unknown
}

enum BodyType: String, Codable {
    case small, medium, large
}

@Model
final class Audio {
    @Attribute(.unique) let id: UUID
    let url: URL
    let name: String
    let duration: TimeInterval
    
    @Relationship(inverse: \Cat.audios) var cat: Cat?

    init(id: UUID = UUID(), url: URL, name: String, duration: TimeInterval) {
        self.id = id
        self.url = url
        self.name = name
        self.duration = duration
    }
}

extension Cat {
    func addAudio(_ audio: Audio) {
        audios.append(audio)
        audio.cat = self
    }
    
    func removeAudio(_ audio: Audio) {
        audios.removeAll { $0.id == audio.id }
        audio.cat = nil
    }
}


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

struct SoundsView: View {
    @Query private var cats: [Cat]
    @State private var selectedCat: Cat?
    
    var body: some View {
        NavigationView {
            VStack {
                if let cat = selectedCat ?? cats.first {
                    Text("Sounds for \(cat.name)")
                        .font(.headline)
                    
                    if cat.audios.isEmpty {
                        Text("No sounds available for this cat.")
                            .foregroundColor(.secondary)
                    } else {
                        List(cat.audios, id: \.id) { audio in
                            HStack {
                                Text(audio.name)
                                Spacer()
                                Text(String(format: "%.1f sec", audio.duration))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } else {
                    Text("No cats available.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Cat Sounds")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Select Cat") {
                        ForEach(cats) { cat in
                            Button(cat.name) {
                                selectedCat = cat
                            }
                        }
                    }
                }
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
