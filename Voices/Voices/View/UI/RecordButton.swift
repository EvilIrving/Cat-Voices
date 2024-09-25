//
//  RecordButton.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

import SwiftUI

// Button for recording sounds
struct RecordButton: View {
    @Binding var isRecording: Bool
    @Binding var cat: Cat
    @StateObject private var audioRecorder = AudioRecorder()

    var body: some View {
        HStack {
            Spacer()

            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                .resizable() // 使图标可调整大小
                .scaledToFit()
                .frame(width: 40, height: 40) // 固定宽高
                .scaleEffect(isRecording ? 0.6 : 1.0) // 录音时缩小 stop 图标
                .font(.largeTitle)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
                .onTapGesture {
                    if isRecording {
                        audioRecorder.stopRecording()
                        if let url = audioRecorder.recordingURL {
                            let soundName = "新录音\(cat.sounds.count + 1)"
                            let sound = Sound(name: soundName, url: url)
                            cat.sounds.append(sound)
                        }
                        isRecording = false
                    } else {
                        audioRecorder.startRecording(count: cat.sounds.count)
                        isRecording = true
                    }
                }
        }
    }
}
