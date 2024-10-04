import SwiftUI
import SwiftData

struct SoundsView: View {
    @Query private var cats: [Cat]
    @State private var selectedCatID: UUID?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            VStack {
                catPicker
                soundsList
            }
            .navigationTitle("Sounds")
            .toolbar {
                Button("Add Sound") {
                    addSound()
                }
                .disabled(selectedCat == nil)
            }
        }
        .onAppear(perform: selectDefaultCat)
    }
    
    private var catPicker: some View {
        Picker("Select Cat", selection: $selectedCatID) {
            ForEach(cats) { cat in
                Text(cat.name).tag(cat.id as UUID?)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
    }
    
    private var soundsList: some View {
        Group {
            if let selectedCat = selectedCat {
                if selectedCat.audios.isEmpty {
                    Text("\(selectedCat.name) doesn't have any sounds yet")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(selectedCat.audios) { audio in
                            HStack {
                                Text(audio.name)
                                Spacer()
                                Text(String(format: "%.1f s", audio.duration))
                            }
                        }
                        .onDelete { indexSet in
                            deleteAudios(for: selectedCat, at: indexSet)
                        }
                    }
                }
            } else {
                Text("No cats available")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
    
    private var selectedCat: Cat? {
        selectedCatID.flatMap { id in cats.first { $0.id == id } } ?? cats.first
    }

    private func selectDefaultCat() {
        if selectedCatID == nil, let firstCat = cats.first {
            selectedCatID = firstCat.id
        }
    }

    private func addSound() {
        guard let cat = selectedCat else { return }
        
        let newAudio = Audio(url: URL(string: "file:///path/to/audio.mp3")!, name: "New Sound", duration: 3.0)
        cat.addAudio(newAudio)
        modelContext.insert(newAudio)
    }
    
    private func deleteAudios(for cat: Cat, at offsets: IndexSet) {
        for index in offsets {
            let audio = cat.audios[index]
            cat.removeAudio(audio)
            modelContext.delete(audio)
        }
    }
}
