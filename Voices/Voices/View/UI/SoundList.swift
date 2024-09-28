//
//  SoundList.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

import AVFoundation
import SwiftUI

struct SoundList: View {
    var body: some View {
        Text("SoundsLsit")
    }
}
//struct SoundsList: View {
//    @EnvironmentObject var vm: CatViewModel
//    @State private var playingSound: Sound?
//    @StateObject private var audioManager = AudioManager()
//    @State private var isEditing = false
//    @State private var editMode: EditMode = .inactive
//    @State private var selectedSound: Sound?
//    @State private var sheetPresented = false
//
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    var body: some View {
//        List {
//            ForEach(vm.cat.sounds, id: \.id) { sound in
//                audioRow(sound: sound)
//            }
//            .onDelete(perform: deleteSounds)
//             
//        }
//        .listStyle(PlainListStyle())
//        .background(Color(.systemBackground))
//        .environment(\.editMode, $editMode)
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
////        .navigationBarItems(trailing: EditButton())
//        .sheet(isPresented: $sheetPresented) {
//            if let sound = selectedSound {
//                AudioEditView(soundToEdit: Binding($selectedSound)!)
//            }
//        }
//    }
//
//    private func audioRow(sound: Sound) -> some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 16) {
//                HStack {
//                    Text(sound.name)
//                        .font(.subheadline)
//
//                    Spacer()
//
//                    Text(audioManager.isPlaying && playingSound == sound ? formatTime(audioManager.currentTime) : formatTime(sound.duration ?? 0.0))
//                        .font(.caption)
//                }
//
//                HStack {
//                    Image(systemName: playingSound == sound && audioManager.isPlaying ? "pause.circle" : "play.circle")
//                        .font(.title)
//                        .foregroundColor(.blue)
//                        .onTapGesture {
//                            if playingSound == sound && audioManager.isPlaying {
//                                audioManager.pause()
//                                playingSound = nil
//                            } else {
//                                playOf(sound: sound)
//                            }
//                        }
//
//                    Image(systemName: "pencil")
//                        .foregroundColor(.blue)
//                        .onTapGesture {
//                            audioManager.pause()
//                            selectedSound = sound
//                            sheetPresented = true
//                        }
//                }
//            }
//        }
//        .padding(.vertical, 8)
//    }
//
//    func playOf(sound: Sound) {
//        audioManager.pause()
//        do {
//            try audioManager.play(url: sound.url)
//            playingSound = sound
//        } catch {
//            print("Unable to play audio file: \(error.localizedDescription)")
//        }
//    }
//
//    func formatTime(_ time: TimeInterval) -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.minute, .second]
//        formatter.zeroFormattingBehavior = .pad
//        return formatter.string(from: time) ?? "00:00"
//    }
//
//    func deleteSounds(at offsets: IndexSet) {
//        let flag = vm.removeSound(at: offsets)
//        if flag == false {
//            alertMessage = "Failed to delete audio file"
//            showAlert = true
//        }
//    }
//}
//
//class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
//    @Published var isPlaying = false
//    @Published var currentTime: TimeInterval = 0
//    private var audioPlayer: AVAudioPlayer?
//    private var timer: Timer?
//
//    func play(url: URL) throws {
//        audioPlayer = try AVAudioPlayer(contentsOf: url)
//        audioPlayer?.delegate = self
//        audioPlayer?.prepareToPlay()
//        audioPlayer?.play()
//        isPlaying = true
//        startTimer()
//    }
//
//    func pause() {
//        audioPlayer?.pause()
//        isPlaying = false
//        stopTimer()
//    }
//
//    private func startTimer() {
//        stopTimer()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//            guard let self = self, let player = self.audioPlayer, player.isPlaying else {
//                self?.stopTimer()
//                return
//            }
//            self.currentTime = player.currentTime
//        }
//    }
//
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        isPlaying = false
//        currentTime = 0
//        stopTimer()
//    }
//}
