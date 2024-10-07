//
//  RecordButton.swift
//  Test
//
//  Created by Actor on 2024/10/7.
//

import AVFoundation
import SwiftUI

// 定义 RecordButton 结构体，用于显示录音按钮
struct RecordButton: View {
    // 使用 @Binding 注解，绑定 isRecording 属性，用于指示是否正在录音
    @Binding var isRecording: Bool
    // 使用 @StateObject 注解，创建 AudioRecorder 对象
    @StateObject private var audioRecorder = AudioRecorder()
    // 使用 @Binding 注解，绑定 cat 属性，用于获取当前选中的猫
    let cat: Cat

    var body: some View {
        HStack {
            Spacer()

            // 显示录音按钮
            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                .resizable() // 使图标可调整大小
                .scaledToFit()
                .frame(width: 30, height: 30) // 固定宽高
                .scaleEffect(isRecording ? 0.6 : 1.0) // 录音时缩小 stop 图标
                .font(.largeTitle)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
                .onTapGesture {
                    // 点击按钮时，根据 isRecording 状态，开始或停止录音
                    if isRecording {
                        audioRecorder.stopRecording()
                        if let url = audioRecorder.recordingURL {
                            let sound = Audio(id: UUID(), url: url, name: url.lastPathComponent)
                            cat.addAudio(sound) // 添加音频到猫的 audios 列表中
                            // 可选：调用 updateDuration() 更新音频时长
                            Task {
                                await sound.updateDuration()
                            }
                        }
                        isRecording = false
                    } else {
                        print("已选中的猫咪:\(cat.name)")
                        audioRecorder.startRecording(cat: cat)
                        isRecording = true
                    }
                }
        }
        .padding()
    }
}
