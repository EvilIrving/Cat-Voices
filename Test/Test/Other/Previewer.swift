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
        
        // Save cats to the container
        container.mainContext.insert(cat1)
        container.mainContext.insert(cat2)
        container.mainContext.insert(cat3)
        
        cats = [cat1, cat2, cat3]
    }
}
