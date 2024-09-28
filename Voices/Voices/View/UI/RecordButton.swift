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
    @StateObject private var audioRecorder = AudioRecorder()
    @State  var cat: Cat
    
    var body: some View {
        HStack {
            Spacer()

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
                    if isRecording {
                        audioRecorder.stopRecording()
                        if let url = audioRecorder.recordingURL {
                            let soundName =  "新录音\(cat.audios.count + 1)"
                                let sound = Sound(name: soundName, url: url)
                        }
                        isRecording = false
                    } else {
                        audioRecorder.startRecording(cat: cat)
                        isRecording = true
                    }
                }
        }
    }
}
