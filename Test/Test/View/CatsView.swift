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

// 添加和编辑猫咪的 Sheet 视图
struct AddAndEditCatView: View {
    @Binding var isPresented: Bool // 绑定 Sheet 的显示状态
    @Environment(\.modelContext) private var modelContext
    @Binding var cat: Cat? // 绑定被选中的猫咪
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var desc: String = ""
    @State private var selectedGender: Gender = .unknown
    @State private var selectedBodyType: BodyType = .medium

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cat Information")) {
                    TextField("Name", text: $name)
                    TextField("Age", text: $age)
                    TextField("Desc", text: $desc)
                }
                Section(header: Text("Gender")) {
                    Picker("Gender", selection: $selectedGender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                }
                Section(header: Text("Body Type")) {
                    Picker("Body Type", selection: $selectedBodyType) {
                        ForEach(BodyType.allCases, id: \.self) { body in
                            Text(body.rawValue).tag(body)
                        }
                    }
                }
            }
            .navigationTitle(cat == nil ? "Add Cat" : "Edit Cat")
            .onAppear {
                if let c = cat {
                    name = c.name
                    age = c.age
                    desc = c.desc
                    selectedGender = c.gender
                    selectedBodyType = c.bodyType
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let c = cat {
                            // 编辑猫咪信息
                            c.name = name
                            c.age = age
                            c.desc = desc
                            c.gender = selectedGender
                            c.bodyType = selectedBodyType
                        } else {
                            // 创建新的猫咪
                            let newCat = Cat(name: name, age: age, desc: desc, gender: selectedGender, bodyType: selectedBodyType)
                            modelContext.insert(newCat)
                        }
                        isPresented = false // 关闭 Sheet
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false // 关闭 Sheet
                    }
                }
            }
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
