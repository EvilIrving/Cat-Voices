import SwiftData
import SwiftUI

struct SoundsView: View {
    // 使用 @Environment 注解，获取 modelContext 对象
    @Environment(\.modelContext) private var modelContext

    // 使用 @Query 注解，获取所有 Cat 对象
    @Query private var cats: [Cat]
    // 使用 @State 注解，声明 selectedCat 属性，用于存储当前选中的猫
    @State private var selectedCat: Cat?
    // 使用 @State 注解，声明 isRecording 属性，用于指示是否正在录音
    @State private var isRecording: Bool = false

    @State private var selectedSound: Audio?
    @State private var playingSound: Audio?
    @StateObject private var audioPlayerVM = AudioPlayerViewModel()

    @State private var showingTrimView = false
    @State private var audioToTrim: Audio?

    var body: some View {
        NavigationView {
            VStack {
                if !cats.isEmpty {
                    if let cat = selectedCat ?? cats.first {
                        if !cat.sortedAudios.isEmpty {
                            Text("\(cat.name) 的声音")
                                .font(.headline)
                        }
                        // 如果 cat 的 audios 列表为空，则显示无音频提示
                        if cat.sortedAudios.isEmpty {
                            Text("\(cat.name) 还没有录制声音哦")
                                .foregroundColor(.secondary)
                        } else {
                            // 使用 List 视图显示猫的音频列表
                            List {
                                ForEach(cat.sortedAudios, id: \.id) { audio in
                                    AudioListItemView(
                                        audio: audio,
                                        audioPlayerVM: audioPlayerVM,
                                        isPlaying: audioPlayerVM.isPlaying
                                            && audioPlayerVM.currentAudioURL
                                                == audio.url,
                                        progress: audioPlayerVM.currentAudioURL
                                            == audio.url
                                            ? audioPlayerVM.progress : 0,
                                        onPlayPause: {
                                            if audioPlayerVM.currentAudioURL
                                                == audio.url
                                            {
                                                audioPlayerVM.togglePlayPause()
                                            } else {
                                                do {
                                                    try audioPlayerVM.loadAudio(
                                                        url: audio.url)
                                                    audioPlayerVM.play()
                                                } catch {
                                                    print(
                                                        "加载音频时出错: \(error.localizedDescription)"
                                                    )
                                                    // 在这里添加用户反馈，例如显示一个警告
                                                }
                                            }
                                        },
                                        onShowTrim: {
                                            audioToTrim = audio
                                        }
                                    )
                                    .listRowInsets(
                                        EdgeInsets(
                                            top: 12, leading: 14, bottom: 12,
                                            trailing: 14)
                                    )
                                    .listRowSeparator(.hidden)
                                    .swipeActions(
                                        edge: .trailing, allowsFullSwipe: true
                                    ) {
                                        Button(role: .destructive) {
                                            deleteAudio(audio: audio)
                                        } label: {
                                            Label("删除", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        }

                        Spacer()

                        // 显示录音按钮
                        if let selectedCat = selectedCat {
                            RecordButton(
                                isRecording: $isRecording, cat: selectedCat)
                        } else {
                            // 如果 selectedCat 为空，则显示提示信息
                            Text("选择猫猫")
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    // 如果没有猫，则显示无猫提
                    Text("没有猫猫，也没有录制声音")
                        .foregroundColor(.secondary)
                }
            }

            .navigationTitle(Text("喵语")).toolbarTitleDisplayMode(.inline)
            .toolbar {
                // 添加一个工具栏按钮，用于选择猫
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(selectedCat?.name ?? "选择猫猫") {
                        // 遍历 cats 列表，为每个猫添加一个按钮
                        ForEach(cats) { cat in
                            Button(cat.name) {
                                selectedCat = cat
                            }
                        }
                    }
                    .disabled(cats.isEmpty)
                }
            }
            .onChange(of: cats) { _, newValue in
                if newValue.isEmpty {
                    selectedCat = nil
                } else if selectedCat == nil
                    || !newValue.contains(where: { $0.id == selectedCat?.id })
                {
                    selectedCat = newValue.first
                }
            }

            .onAppear {
                // 在视图出现时，如果 selectedCat 为空，则将 selectedCat 设置为 cats 的第一个元素
                if selectedCat == nil && !cats.isEmpty {
                    selectedCat = cats[0]
                }
            }

            .sheet(item: $audioToTrim) { audio in
                AudioTrimView(audio: audio)
            }
        }
    }

    // 删除声音的方法
    private func deleteAudio(audio: Audio) {
        // 删除关联的音频文件
        do {
            try FileManager.default.removeItem(at: audio.url)
        } catch {
            print("删除音频文件失败: \(error.localizedDescription)")
        }

        // 从数据库中删除音频
        modelContext.delete(audio)

        // 如果当前正在播放这个音频，停止播放
        if audioPlayerVM.currentAudioURL == audio.url {
            audioPlayerVM.pause()
            audioPlayerVM.currentAudioURL = nil
        }

        // 从猫咪的音频列表中移除
        if let index = selectedCat?.audios.firstIndex(where: {
            $0.id == audio.id
        }) {
            selectedCat?.audios.remove(at: index)
        }
    }
}

// 预览代码
#Preview {
    do {
        let previewer = try MP3Preview()
        return SoundsView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
