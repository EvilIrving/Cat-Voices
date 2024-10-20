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
    
    // 修改动画状态的范围
    @State private var animationAmount: CGFloat = 0.8
    @State private var lineWidth: CGFloat = 5

    var body: some View {
        HStack {
            Spacer()

            // 使用固定大小的容器
            ZStack {
                // 只在录音时显示动态光圈
                if isRecording {
                    Circle()
                        .stroke(Color.accentColor.opacity(0.7), lineWidth: lineWidth)
                        .scaleEffect(animationAmount)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: false),
                            value: animationAmount
                        )
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: false),
                            value: lineWidth
                        )
                        .onAppear {
                            animationAmount = 1
                            lineWidth = 1
                        }
                }

                // 录音按钮
                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .scaleEffect(isRecording ? 0.6 : 1.0)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .frame(width: 80, height: 80) // 固定 ZStack 的大小
            .onTapGesture {
                isRecording.toggle() // 直接切换录音状态
                if isRecording {
                    print("开始录音")
                    audioRecorder.startRecording(cat: cat)
                    withAnimation {
                        animationAmount = 1
                        lineWidth = 1
                    }
                } else {
                    print("停止录音")
                    audioRecorder.stopRecording()
                    if let url = audioRecorder.recordingURL {
                        let fileName = url.deletingPathExtension().lastPathComponent
                        let sound = Audio(id: UUID(), url: url, name: fileName)
                        cat.addAudio(sound)
                        Task {
                            await sound.updateDuration()
                            await sound.generateWaves()
                        }
                    }
                    withAnimation {
                        animationAmount = 0.8
                        lineWidth = 5
                    }
                }
            }
        }
        .padding()
    }
}
