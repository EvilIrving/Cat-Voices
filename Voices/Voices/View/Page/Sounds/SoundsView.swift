import SwiftData
import SwiftUI

struct SoundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(Cat.self) private var cats: [Cat]

    @State private var selectedCat: Cat?

    var body: some View {
        NavigationStack {
            VStack {
                // 猫咪选择器
                Picker("Select a Cat", selection: $selectedCat) {
                    ForEach(cats, id: \.name) { cat in
                        Text(cat.name).tag(cat as Cat?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // 显示音频列表
                List {
                    if let audios = selectedCat?.audios {
                        ForEach(audios, id: \.self) { sound in
                            Text(sound.description) // 假设 Sound 有一个 description 属性
                        }
                    } else {
                        Text("No audio recordings available.")
                    }
                }
                .navigationTitle("Sounds")
                .onAppear {
                    // 设置默认选择的猫咪
                    if cats.isEmpty {
                        selectedCat = nil
                    } else {
                        selectedCat = cats.first
                    }
                }
            }
            .padding()
        }
    }
}
