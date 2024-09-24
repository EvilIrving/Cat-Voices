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
            Button(action: {
                if isRecording {
                    audioRecorder.stopRecording()
                    if let url = audioRecorder.recordingURL {
                        let soundName = "新录音\(cat.sounds.count + 1)"
                        let sound = Sound(name: soundName, soundURL: url)
                        cat.sounds.append(sound)
                    }
                    isRecording = false
                } else {
                    audioRecorder.startRecording()
                    isRecording = true
                }
            }) {
                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .padding()
        }
    }
}
