//
//  SoundsView.swift
//  Test
//
//  Created by Actor on 2024/10/7.
//

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
    @StateObject private var audioManager = AudioManager()

    @State private var showingTrimView = false
    @State private var audioToTrim: Audio?

    var body: some View {
        NavigationView {
            VStack {
                // 如果 selectedCat 或 cats.first 不为空，则显示选中的猫的音频列表
                if let cat = selectedCat ?? cats.first {
                    Text("Sounds for \(cat.name)")
                        .font(.headline)

                    // 如果 cat 的 audios 列表为空，则显示无音频提示
                    if cat.audios.isEmpty {
                        Text("No sounds available for this cat.")
                            .foregroundColor(.secondary)
                    } else {
                        // 使用 List 视图显示猫的音频列表
                        List(cat.audios, id: \.id) { audio in
                            HStack {
                                Text(audio.name)
                                Spacer()
                                // 显示音频时长
                                Text(String(format: "%.1f sec", audio.duration))
                                    .foregroundColor(.secondary)

                                HStack {
                                    Image(systemName: playingSound == audio && audioManager.isPlaying ? "pause.circle" : "play.circle")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            // 播放声音逻辑
                                            if playingSound == audio && audioManager.isPlaying {
                                                audioManager.pause()
                                                playingSound = nil
                                            } else {
                                                playOf(sound: audio)
                                            }
                                        }

                                    Image(systemName: "trash")
                                        .font(.title) // 保持与播放按钮大小一致
                                        .foregroundColor(.red)
                                        .onTapGesture {
                                            deleteAudio(audio: audio)
                                        }

                                    Image(systemName: "pencil")
                                        .font(.title) // 保持与播放按钮大小一致
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            audioToTrim = audio
                                            pauseAudio()
                                            showingTrimView = true
                                        }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color(.systemBackground))
                    }

                    Spacer()

                    // 显示录音按钮
                    if let selectedCat = selectedCat {
                        RecordButton(isRecording: $isRecording, cat: selectedCat)
                    } else {
                        // 如果 selectedCat 为空，则显示提示信息
                        Text("Please select a cat.")
                            .foregroundColor(.secondary)
                    }
                } else {
                    // 如果没有猫，则显示无猫提示
                    Text("No cats available.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Cat Sounds")
            .toolbar {
                // 添加一个工具栏按钮，用于选择猫
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(selectedCat?.name ?? "Select Cat") {
                        // 遍历 cats 列表，为每个猫添加一个按钮
                        ForEach(cats) { cat in
                            Button(cat.name) {
                                selectedCat = cat
                            }
                        }
                    }
                }
            }

            .onAppear {
                // 在视图出现时，如果 selectedCat 为空，则将 selectedCat 设置为 cats 的第一个元素
                if selectedCat == nil && !cats.isEmpty {
                    selectedCat = cats[0]
                }
            }

            .sheet(isPresented: $showingTrimView) {
                if let audioToTrim = audioToTrim {
                    AudioTrimView(audio: audioToTrim)
                }
            }
        }
    }

    // 暂停当前正在播放的音频
    private func pauseAudio() {
        audioManager.pause()
        audioManager.isPlaying = false
    }

    private func playOf(sound: Audio) {
        audioManager.pause()
        do {
            try audioManager.play(url: sound.url)
            playingSound = sound
        } catch {
            print("Unable to play audio file: \(error.localizedDescription)")
        }
    }

    // 删除声音的方法
    private func deleteAudio(audio: Audio) {
        // 删除关联的音频文件
        try? FileManager.default.removeItem(at: audio.url)

        // 从数据库中删除音频
        modelContext.delete(audio)
    }
}

// 预览代码
#Preview {
    do {
        let previewer = try Previewer()
        return SoundsView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
