import SwiftData


@MainActor
struct Previewer {
    let container: ModelContainer
    
    let cat: Cat

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Cat.self, configurations: config)

       
        cat = Cat(name: "Dave Lister", age: "23",   desc: "some")

        container.mainContext.insert(cat)
    }
}
