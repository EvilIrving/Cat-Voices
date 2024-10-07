//
//  EditView.swift
//  audiodemo
//
//  Created by Actor on 2024/9/23.
//

import AVFoundation
import SwiftUI

struct EditView: View {
    @Binding var audioFile: AudioFile
    @Environment(\.presentationMode) var presentationMode
    @State private var audioPlayer: AVAudioPlayer?
    @State private var start: TimeInterval = 0
    @State private var end: TimeInterval = 0
    @State private var duration: TimeInterval = 0
    @State private var cpFile: AudioFile?
    @State private var error: Error?

    init(audioFile: Binding<AudioFile>) {
        _audioFile = audioFile
        do {
            let (destinationFileName, destinationURL) = try copyFile(from: audioFile.wrappedValue.url)

            print(destinationFileName, destinationURL, "123")
            cpFile = AudioFile(name: destinationFileName, url: destinationURL)
            print(cpFile ?? "111")

        } catch {
            print("copyFile Failed")
            self.error = error
        }

        loadAudio()
    }

    var body: some View {
        VStack {
            Form {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 30)

                        // the audio edit slider
                        HStack {
                            // start slider
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 10, height: 50)
                                .offset(x: 0)

                            // end slider
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 10, height: 50)
                                .offset(x: end / duration * geometry.size.width)
                        }
                    }
                }
                .frame(height: 50)
                .padding()

                VStack {
                    Button("Save") {
                        Task {
                            await saveAudio()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding() // 添加内边距
                    .background(Color.blue) // 设置背景颜色，发送中时为灰色
                    .foregroundColor(.white) // 设置文本颜色为白色
                    .cornerRadius(10) // 设置圆角
                    .shadow(radius: 5) // 设置阴影
                    .padding(.horizontal) // 水平方向的内边距
                }
                .padding()
            }
        }
        .navigationBarTitle("Edit Audio File", displayMode: .inline)
    }

    func loadAudio() {
        guard let cpoyFile = cpFile else {
            print("Error loading audio.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: cpoyFile.url)
            duration = audioPlayer?.duration ?? 0
            end = duration
            start = 0

            print(start, duration, end)
        } catch {
            print("Error AVAudioPlayer Loading Resource.")
        }
    }

    func saveAudio() async {
        // 修改副本文件
        // 保存副本文件
    }

    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let second = Int(time) % 60
        return String(format: "%02d:%02d", minute, second)
    }
}
