import SwiftUI
import AVFoundation
 
struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var audioFiles: [AudioFile] = []
    @State private var currentlyPlayingIndex: Int?
    @State private var isEditViewPresented = false
    @State private var selectedAudioFile: AudioFile?

    // 定时器，用于实时更新播放进度
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var currentTime: TimeInterval = 0.0

    var body: some View {
        NavigationView {
            List {
                ForEach(audioFiles.indices, id: \.self) { index in
                    audioRow(file: audioFiles[index], index: index)
                }
            }
            .sheet(isPresented: $isEditViewPresented) {
                if let audioFile = selectedAudioFile {
                    EditView(audioFile: binding(for: audioFile))
                }
            }
            .navigationBarTitle("Audio List")
            .onAppear {
                loadAudioFiles()
                selectedAudioFile = audioFiles.last
            }
            .onReceive(timer) { _ in
                // 更新当前播放进度
                if isPlaying, let player = audioPlayer {
                    currentTime = player.currentTime
                }
            }
            .onDisappear {
                // 停止定时器
                timer.upstream.connect().cancel()
            }
        }
    }

    private func binding(for audioFile: AudioFile) -> Binding<AudioFile> {
        guard let index = audioFiles.firstIndex(where: { $0.id == audioFile.id }) else {
            fatalError("Can't find audio file in array")
        }
        return $audioFiles[index]
    }

    func loadAudioFiles() {
        let audioFilesPaths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)

        audioFiles = audioFilesPaths.compactMap { path in
            let url = URL(fileURLWithPath: path)
            let name = url.deletingPathExtension().lastPathComponent
            return AudioFile(name: name, url: url)
        }
    }

    func playAudio(file: AudioFile) {
        if let index = audioFiles.firstIndex(where: { $0.id == file.id }) {
            if currentlyPlayingIndex == index && isPlaying {
                audioPlayer?.pause()
                isPlaying = false
            } else {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: file.url)
                    audioPlayer?.play()
                    currentlyPlayingIndex = index
                    isPlaying = true
                } catch {
                    print("Error playing audio file: \(error)")
                }
            }
        }
    }

    // 暂停当前正在播放的音频
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
        currentlyPlayingIndex = nil
        currentTime = 0.0
    }

    private func audioRow(file: AudioFile, index: Int) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(file.name)

                HStack {
                    if let player = audioPlayer, currentlyPlayingIndex == index && isPlaying {
                        let endTime = player.duration - currentTime
                        Text("Start: \(formatTime(currentTime))")
                        Text("End: \(formatTime(endTime))")
                        Text("Duration: \(formatTime(player.duration))")
                    } else {
                        if let duration = file.duration {
                            Text("Start: 0.0")
                            Text("End: \(formatTime(duration))")
                            Text("Duration: \(formatTime(duration))")
                        } else {
                            Text("Start: 0.0")
                            Text("End: 0.0")
                            Text("Duration: 0.0")
                        }
                    }
                }

                HStack {
                    Image(systemName: currentlyPlayingIndex == index && isPlaying ? "pause.circle" : "play.circle")
                        .font(.title)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            playAudio(file: file)
                            isEditViewPresented = false
                        }

                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            pauseAudio()
                            selectedAudioFile = file
                            isEditViewPresented = true
                        }
                }
            }
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: time) ?? "0:00"
    }
} 
#Preview {
    ContentView()
}
