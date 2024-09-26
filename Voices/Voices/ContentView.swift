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
    @StateObject private var vm =  CatViewModel()
    @State private var isRecording = false
    @StateObject private var audioRecorder = AudioRecorder()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(vm.cat.name)").font(.headline)
                
                // Display the cat's sounds
                if vm.cat.sounds.isEmpty {
                    Text("还没有录入声音哦")
                        .font(.title3)
                        .padding()
                } else {
                    SoundsList( )
                }
                
                Spacer()
                
                // Floating record button
                RecordButton(isRecording: $isRecording)
            }
            .padding()
        }
        .environmentObject(vm) // 将 CatsViewModel 通过 EnvironmentObject 传递给子视图
    }
}

#Preview {
    ContentView()
}
