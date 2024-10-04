import SwiftUI
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let cats: [Cat]
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Cat.self, Audio.self, configurations: config)
        
        // Create sample cats
        let cat1 = Cat(name: "Whiskers", age: "3", desc: "Playful tabby", gender: .male, bodyType: .medium)
        let cat2 = Cat(name: "Mittens", age: "5", desc: "Lazy Persian", gender: .female, bodyType: .large)
        let cat3 = Cat(name: "Socks", age: "2", desc: "Energetic Siamese", gender: .male, bodyType: .small)
        
        // Create sample sounds
        let sound1 = Audio(url: URL(string: "file:///meow.mp3")!, name: "Meow", duration: 1.5)
        let sound2 = Audio(url: URL(string: "file:///purr.mp3")!, name: "Purr", duration: 2.0)
        let sound3 = Audio(url: URL(string: "file:///hiss.mp3")!, name: "Hiss", duration: 1.0)
        
        // Add sounds to cats
        cat1.addAudio(sound1)
        cat1.addAudio(sound2)
        cat2.addAudio(sound3)
        
        // Save cats and sounds to the container
        container.mainContext.insert(cat1)
        container.mainContext.insert(cat2)
        container.mainContext.insert(cat3)
        
        cats = [cat1, cat2, cat3]
    }
}


