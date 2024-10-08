import SwiftUI

/// 添加和编辑猫咪的 Sheet 视图
struct AddAndEditCatView: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    @Binding var cat: Cat?
    
    // MARK: - State
    @State private var catInfo: CatInfo
    
    // MARK: - Initialization
    init(isPresented: Binding<Bool>, cat: Binding<Cat?>) {
        self._isPresented = isPresented
        self._cat = cat
        self._catInfo = State(initialValue: CatInfo(cat: cat.wrappedValue))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                catInfoSection
                genderSection
                bodyTypeSection
            }
            .navigationTitle(cat == nil ? "Add Cat" : "Edit Cat")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { saveButton }
                ToolbarItem(placement: .navigationBarLeading) { cancelButton }
            }
        }
    }
    
    // MARK: - View Components
    private var catInfoSection: some View {
        Section(header: Text("Cat Information")) {
            TextField("Name", text: $catInfo.name)
            TextField("Age", text: $catInfo.age)
                .keyboardType(.numberPad)
            TextField("Description", text: $catInfo.desc)
        }
    }
    
    private var genderSection: some View {
        Section(header: Text("Gender")) {
            Picker("Gender", selection: $catInfo.gender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue.capitalized).tag(gender)
                }
            }
        }
    }
    
    private var bodyTypeSection: some View {
        Section(header: Text("Body Type")) {
            Picker("Body Type", selection: $catInfo.bodyType) {
                ForEach(BodyType.allCases, id: \.self) { body in
                    Text(body.rawValue).tag(body)
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            saveCat()
            isPresented = false
        }
        .disabled(catInfo.name.isEmpty)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            isPresented = false
        }
    }
    
    // MARK: - Helper Methods
    private func saveCat() {
        if let existingCat = cat {
            updateExistingCat(existingCat)
        } else {
            createNewCat()
        }
    }
    
    private func updateExistingCat(_ existingCat: Cat) {
        existingCat.update(with: catInfo)
    }
    
    private func createNewCat() {
        let newCat = Cat(info: catInfo)
        modelContext.insert(newCat)
    }
}

// MARK: - Supporting Types
/// 用于存储和管理猫咪信息的结构体
struct CatInfo {
    var name: String = ""
    var age: String = ""
    var desc: String = ""
    var gender: Gender = .unknown
    var bodyType: BodyType = .medium
    
    init(cat: Cat?) {
        if let cat = cat {
            name = cat.name
            age = cat.age
            desc = cat.desc
            gender = cat.gender
            bodyType = cat.bodyType
        }
        // 如果 cat 为 nil，则使用默认值
    }
}

// MARK: - Cat Extension
extension Cat {
    convenience init(info: CatInfo) {
        self.init(name: info.name, age: info.age, desc: info.desc, gender: info.gender, bodyType: info.bodyType)
    }
    
    func update(with info: CatInfo) {
        name = info.name
        age = info.age
        desc = info.desc
        gender = info.gender
        bodyType = info.bodyType
    }
}
