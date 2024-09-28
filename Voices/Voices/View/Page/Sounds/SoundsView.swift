import SwiftData
import SwiftUI

struct SoundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var cats: [Cat]
    @State private var selectedCat: Cat?
    @State private var isRecording = false
    @StateObject private var audioRecorder = AudioRecorder()
    
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
                if let audios = selectedCat?.audios, audios.count > 0 {
                    List {
                        ForEach(audios, id: \.self) { sound in
                            Text(sound.name)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color(.systemBackground))
                    .onAppear {
                        // 设置默认选择的猫咪
                        if cats.isEmpty {
                            selectedCat = nil
                        } else {
                            selectedCat = cats.first
                        }
                    }
                } else {
                    Text("还没有录入声音哦")
                        .font(.title3)
                        .padding()
                }
                Spacer()
                RecordButton(isRecording: $isRecording,cat:selectedCat!)
            }
            .padding()
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return SoundsView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
