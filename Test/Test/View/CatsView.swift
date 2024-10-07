import SwiftData
import SwiftUI

struct CatsView: View {
    @Query private var cats: [Cat]
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingCat = false // 控制是否显示添加猫咪的 Sheet
    @State private var selectedCat: Cat? // 用于存储被选中的猫咪

    var body: some View {
        NavigationView {
            List {
                ForEach(cats) { cat in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(cat.name)
                                .font(.headline)
                            Text("Age: \(cat.age)")
                                .font(.subheadline)
                        }

                        Spacer()

                        Image(systemName: "square.and.pencil.circle")
                            .foregroundColor(.blue)
                            .font(.title)
                            .onTapGesture {
                                selectedCat = cat // 选择猫咪
                                isAddingCat = true // 显示编辑猫咪的 Sheet
                            }
                    }
                }
                .onDelete(perform: deleteCat)
            }
            .navigationTitle("Cats")
            .toolbar {
                Button("Add Cat") {
                    isAddingCat = true // 显示添加猫咪的 Sheet
                }
            }
            .sheet(isPresented: $isAddingCat) {
                AddAndEditCatView(isPresented: $isAddingCat, cat: $selectedCat) // 传递 selectedCat
            }
        }
    }

    private func deleteCat(at offsets: IndexSet) {
        for index in offsets {
            let cat = cats[index]
            // 删除关联的音频文件
            for audio in cat.audios {
                try? FileManager.default.removeItem(at: audio.url)
            }

            // Assuming 'cat.audios' contains the path to the folder
            if let folderURL = cat.audios.first?.url.deletingLastPathComponent() {
                // Delete the folder recursively
                try? FileManager.default.removeItem(at: folderURL)
            }
            // 从数据库中删除猫咪
            modelContext.delete(cat)
        }
    }
}



// 预览代码
#Preview {
    do {
        let previewer = try Previewer()
        return CatsView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
