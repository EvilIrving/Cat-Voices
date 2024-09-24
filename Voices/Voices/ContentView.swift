//
//  ContentView.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

import SwiftUI
import AVFoundation

// Main ContentView display the cat sounds and record button
struct ContentView: View {
    @State private var cat = Cat(id: UUID(), name: "罗小黑", sounds: [], description: "一个小黑猫，总是很调皮。")
    @State private var isRecording = false
    @StateObject private var audioRecorder = AudioRecorder()
    
    var body: some View {
        NavigationView {
            VStack {
                // Display the cat's sounds
                if cat.sounds.isEmpty {
                    Text("还没有录入声音哦")
                        .font(.title3)
                        .padding()
                } else {
                    SoundsList(cat: $cat)
                }
                
                Spacer()
                
                // Floating record button
                RecordButton(isRecording: $isRecording, cat:$cat)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
