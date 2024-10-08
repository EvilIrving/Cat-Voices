import SwiftData
import SwiftUI

struct CatsView: View {
    @Query var cats: [Cat]
    @State private var path = [Cat]()
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(cats) { cat in
                    NavigationLink(value: cat) {
                        Text(cat.name)
                    }
                }
            }
            .navigationTitle("Cats")
            .navigationDestination(for: Cat.self) { cat in
                EditCatView(cat: cat)
            }
            .toolbar {
                Button("Add Cat", systemImage: "plus", action: addCat)
            }
        }
    }

    func addCat() {
        let cat = Cat(name: "", age: "", desc: "")
        path.append(cat)
    }
}


//
//#Preview {
//    do {
//        let previewer = try Previewer()
//        return CatsView()
//            .modelContainer(previewer.container)
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}
