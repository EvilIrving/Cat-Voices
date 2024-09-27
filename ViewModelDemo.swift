//
//  ContentView.swift
//  ViewModelDemo
//
//  Created by Actor on 2024/9/25.
//

import SwiftUI
struct Cat: Identifiable {
    let id = UUID() // 确保每只猫都有唯一的 ID
    var name: String
}

class CatsViewModel: ObservableObject {
    @Published var cats = [Cat(name: "Whiskers"), Cat(name: "Baibai")]

    // 添加一只猫
    func addCat(name: String) {
        cats.append(Cat(name: name))
    }

    // 删除一只猫
    func deleteCat(at offsets: IndexSet) {
        cats.remove(atOffsets: offsets)
    }

    // 更新猫的名字
    func updateCat(cat: Cat, newName: String) {
        if let index = cats.firstIndex(where: { $0.id == cat.id }) {
            cats[index].name = newName
        }
    }
}

struct ContentView: View {
    @StateObject private var vm = CatsViewModel() // 在 ContentView 内部创建 CatsViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.cats) { cat in
                    NavigationLink(destination: EditCatView(cat: cat)) {
                        Text(cat.name)
                    }
                }
                .onDelete(perform: vm.deleteCat)
            }
            .navigationTitle("Cats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddCatView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .environmentObject(vm) // 将 CatsViewModel 通过 EnvironmentObject 传递给子视图
    }
}
 

struct EditCatView: View {
    @EnvironmentObject var viewModel: CatsViewModel
    @Environment(\.presentationMode) var presentationMode // 添加这个属性来控制返回
    var cat: Cat
    @State private var newName: String

    init(cat: Cat) {
        self.cat = cat
        _newName = State(initialValue: cat.name)
    }

    var body: some View {
        Form {
            TextField("Cat's name", text: $newName)
            Button("Save") {
                viewModel.updateCat(cat: cat, newName: newName)
                presentationMode.wrappedValue.dismiss() // 保存后返回上一个视图
            }
        }
        .navigationTitle("Edit \(cat.name)")
    }
}

struct AddCatView: View {
    @EnvironmentObject var viewModel: CatsViewModel
    @Environment(\.presentationMode) var presentationMode // 添加这个属性来控制返回
    @State private var name: String = ""

    var body: some View {
        Form {
            TextField("New cat's name", text: $name)
            Button("Add Cat") {
                if !name.isEmpty {
                    viewModel.addCat(name: name)
                    name = ""
                    presentationMode.wrappedValue.dismiss() // 添加后返回上一个视图
                }
            }
        }
        .navigationTitle("Add New Cat")
    }
}


#Preview {
    ContentView()
}
