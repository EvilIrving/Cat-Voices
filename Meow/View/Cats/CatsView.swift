import SwiftData
import SwiftUI

struct CatsView: View {
    @StateObject private var languageManager = LanguageManager.shared   
    @Query private var cats: [Cat]
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingCat = false
    @State private var selectedCat: Cat?

    var body: some View {
        NavigationView {
            List {
                ForEach(cats) { cat in
                    HStack {
                        if let avatarURL = cat.avatar, let uiImage = UIImage(contentsOfFile: avatarURL.path) {
                            Image(uiImage: uiImage)
                                .resizable()
                                // .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "photo")
                                .frame(width: 50, height: 50)
                        }

                        VStack(alignment: .leading) {
                            Text(cat.name)
                                .font(.headline)
                            Text("Breed: \(cat.breed.rawValue)")
                                .font(.subheadline)
                            if let birthDate = cat.birthDate {
                                Text("年龄: \(Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0)岁")
                                    .font(.subheadline)
                            }
                        }

                        Spacer()

                        Image(systemName: "square.and.pencil.circle")
                            .foregroundColor(.blue)
                            .font(.title)
                            .onTapGesture {
                                selectedCat = cat
                                isAddingCat = true
                            }
                    }
                }
                .onDelete(perform: deleteCat)
            }
            .navigationTitle("猫咪列表").toolbarTitleDisplayMode(.inline)
            .toolbar {
                Button("Add Cat".localised(using: languageManager.selectedLanguage)) {
                    isAddingCat = true
                    selectedCat = nil
                }
            }
            .sheet(isPresented: $isAddingCat) {
                AddAndEditCatView(isPresented: $isAddingCat, cat: $selectedCat)
            }
        }
    }

    private func deleteCat(at offsets: IndexSet) {
        for index in offsets {
            let cat = cats[index]

            // 删除与猫咪相关的体重记录
            for weight in cat.weights {
                modelContext.delete(weight)
            }

            // 删除与猫咪相关的提醒
            for event in cat.events {
                modelContext.delete(event)
            }

            // 删除关联的音频文件
            for audio in cat.audios {
                do {
                    try FileManager.default.removeItem(at: audio.url)
                } catch {
                    print("删除猫咪 \(cat.name) 的音频文件时发生错误: \(error.localizedDescription)")
                }
            }

            // 删除头像文件
            if let avatarURL = cat.avatar {
                do {
                    try FileManager.default.removeItem(at: avatarURL)
                    print("成功删除猫咪 \(cat.name) 的头像文件")
                } catch {
                    print("删除猫咪 \(cat.name) 的头像文件时发生错误: \(error.localizedDescription)")
                }
            }

            // 删除文件夹
            if let folderURL = cat.audios.first?.url.deletingLastPathComponent() {
                do {
                    try FileManager.default.removeItem(at: folderURL)
                } catch {
                    print("删除猫咪 \(cat.name) 的文件夹时发生错误: \(error.localizedDescription)")
                }
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
            .environmentObject(AppState())
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
