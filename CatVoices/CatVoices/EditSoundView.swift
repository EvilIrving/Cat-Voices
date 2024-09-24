//
//  EditSoundView.swift
//  CatVoices
//
//  Created by Actor on 2024/9/18.
//
import SwiftUI
import AVFoundation

struct EditSoundView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cat: Cat
    @Binding var soundToEdit: Sound
    @State private var fromTime: Double = 0
    @State private var toTime: Double = 0
    @State private var soundDuration: Double = 0
    @State private var soundName: String = ""
    @State private var audioPlayer: AVAudioPlayer?
    @State private var waveformImage: UIImage?
    
    @State private var sliderValue: Double = 0
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("剪辑声音")) {
                    
                   
                    
                    //                    Text("Slider Value: \(sliderValue)")
                    //                                // 使用 CustomSlider
                    //                                CustomSlider(value: $sliderValue)
                }
                
                Section(header: Text("修改名称")) {
                    TextField("名称", text: $soundName)
                }
                
                Section {
                    Button("保存") {
                        saveSound()
                    }
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("编辑声音", displayMode: .inline)
            .onAppear {
                soundName = soundToEdit.name
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundToEdit.soundURL)
                    soundDuration = audioPlayer?.duration ?? 0
                    print(soundDuration,"")
                } catch {
                    print("Failed to load sound: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveSound() {
        do {
            let oldURL = soundToEdit.soundURL
            let newURL = FileManager.default.temporaryDirectory.appendingPathComponent("editedSound.m4a")
            
            let asset = AVAsset(url: oldURL)
            let startTime = CMTime(seconds: fromTime, preferredTimescale: 1)
            let durationTime = CMTime(seconds: toTime - fromTime, preferredTimescale: 1)
            
            let startTimeRange = CMTimeRange(start: startTime, duration: durationTime)
            let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)!
            exporter.timeRange = startTimeRange
            exporter.outputURL = newURL
            exporter.outputFileType = .m4a
            
            exporter.exportAsynchronously {
                switch exporter.status {
                case .completed:
                    let newSound = Sound(name: soundName, soundURL: newURL)
                    if let index = cat.sounds.firstIndex(of: soundToEdit) {
                        cat.sounds[index] = newSound
                    }
                    presentationMode.wrappedValue.dismiss()
                case .failed, .cancelled:
                    print("Export failed: \(exporter.error!.localizedDescription)")
                default:
                    break
                }
            }
        } catch {
            print("Failed to export sound: \(error.localizedDescription)")
        }
    }
}
