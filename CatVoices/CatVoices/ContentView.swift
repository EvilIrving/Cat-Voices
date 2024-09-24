import SwiftUI
import AVFoundation

// Main ContentView displaying the cat's sounds and record button
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

struct SoundsList: View {
    @Binding var cat: Cat
    @State private var playingSound: Sound?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isEditing = false
    @State private var editMode: EditMode = .inactive
    @State private var selectedSound: Sound?
    @State private var sheetPresented = false
    
    @State private var timer: Timer?
    @State private var currentTime: TimeInterval = 0
    private var duration: TimeInterval {
        audioPlayer?.duration ?? 0
    }
    
    var body: some View {
        List {
            ForEach(cat.sounds, id: \.id) { sound in
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("这里是波形图")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {
                                sheetPresented = false
                                handlePlayPause(sound: sound)
                            }) {
                                Image(systemName: (playingSound == sound && audioPlayer?.isPlaying == true) ? "stop.fill" : "play.fill")
                                    .font(.title3)
                                    .padding()
                            }
                        }
                        
                        HStack {
                            Text(formatTime(currentTime))
                                .font(.caption)
                            Spacer()
                            Text(formatTime(duration))
                                .font(.caption)
                        }
                        
                        HStack {
                            Text(sound.name)
                                .font(.subheadline)
                            Spacer()
                            Button(action: {
                                selectedSound = sound
                                sheetPresented = true
                            }) {
                                Image(systemName: "pencil")
                                    .font(.title3)
                                    .padding()
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .onDelete(perform: deleteSound)
        }
        .listStyle(PlainListStyle())
        .background(Color(.systemBackground))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                withAnimation {
                    isEditing.toggle()
                    editMode = isEditing ? .active : .inactive
                }
            }) {
                Text(isEditing ? "完成" : "编辑")
            }
        })
        .environment(\.editMode, $editMode)
        .sheet(isPresented: $sheetPresented) {
            if let sound = selectedSound {
                EditSoundView(cat: $cat, soundToEdit: .constant(sound))
            }
        }
    }
    
    func handlePlayPause(sound: Sound) {
        if playingSound == sound {
            if audioPlayer?.isPlaying == true {
                startTimer()
                audioPlayer?.stop()
                playingSound = nil
            } else {
                timer?.invalidate()
                currentTime = 0
                audioPlayer?.play()
            }
        } else {
            audioPlayer?.stop()
            do {
                let fileManager = FileManager.default
                let filePath = sound.soundURL.path
                
                if fileManager.fileExists(atPath: filePath) {
                    audioPlayer = try AVAudioPlayer(contentsOf: sound.soundURL)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    playingSound = sound
                } else {
                    print("Error: File does not exist at path \(filePath)")
                }
            } catch {
                print("Failed to play sound: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteSound(at offsets: IndexSet) {
        cat.sounds.remove(atOffsets: offsets)
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            guard let player = audioPlayer, player.isPlaying else {
                timer?.invalidate()
                return
            }
            currentTime = player.currentTime
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: time) ?? "00:00"
    }
}

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

// Model for Cat
struct Cat: Identifiable {
    var id: UUID
    var name: String
    var sounds: [Sound]
    var description: String
}

// Model for Sound

struct Sound: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var URL: URL
    
    // Implement equality based on id
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.id == rhs.id
    }
}
#Preview {
    ContentView()
}
