import SwiftUI

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
                    // TODO 校验年龄
                    TextField("Age", text: $age)
//                    TextField("Age", text: $age)
//                        .keyboardType(.numberPad)
//                        .placeholder(when: age.isEmpty) {
//                            Text("不可以超过 30 岁哦")
//                                .foregroundColor(.gray)
//                        }
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
                    .disabled(name.isEmpty) // 当名字为空时禁用保存按钮
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
