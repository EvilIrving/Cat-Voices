import SwiftUI
import AVFoundation


struct AudioFile: Identifiable {
    let id = UUID()
    var name: String
    var url: URL
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var duration: TimeInterval? // 总时长
    
    // 自定义初始化方法
    init(name: String, url: URL) {
        self.name = name
        self.url = url
        
        // 初始化 AVAudioPlayer 并获取音频时长
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            self.duration = player.duration
            self.endTime = player.duration // 初始时，endTime 即为文件的时长
        } catch {
            print("Error initializing AVAudioPlayer: \(error)")
            self.duration = nil
        }
    }
}

struct WaveformView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for x in 0..<Int(geometry.size.width) {
                    let height = CGFloat.random(in: 0.1...1.0) * geometry.size.height
                    let y = (geometry.size.height - height) / 2
                    path.move(to: CGPoint(x: CGFloat(x), y: y))
                    path.addLine(to: CGPoint(x: CGFloat(x), y: y + height))
                }
            }
            .stroke(Color.blue, lineWidth: 1)
        }
    }
}

struct EditView: View {
    @Binding var audioFile: AudioFile
    @Environment(\.presentationMode) var presentationMode
    @State private var editedName: String
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0
    @State private var duration: TimeInterval = 0
    @State private var isNameValid = false
    
    init(audioFile: Binding<AudioFile>) {
        self._audioFile = audioFile
        self._editedName = State(initialValue: audioFile.wrappedValue.name)
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("File Information")) {
                    TextField("File Name", text: $editedName)
                        .onChange(of: editedName) { _ in
                            validateFileName(editedName)
                        }
                    
                    if !isNameValid {
                        Text("File name must not be empty and contain only letters, numbers, and underscores")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                WaveformView()
                    .frame(height: 100)
                    .padding()
                
                HStack {
                    Text(timeString(time:  audioFile.startTime))
                    Spacer()
                    Text(timeString(time: audioFile.endTime))
                }
                .padding(.horizontal)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 30)
                        
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: CGFloat(currentTime / duration) * geometry.size.width, height: 30)
                        
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 10, height: 50)
                                .offset(x: CGFloat(audioFile.startTime / duration) * geometry.size.width)
                                .gesture(DragGesture().onChanged { value in
                                    let newStart = Double(value.location.x) / geometry.size.width * duration
                                    audioFile.startTime = max(0, min(newStart, audioFile.endTime - 1))
                                })
                            
                            
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 10, height: 50)
                                .offset(x: CGFloat(audioFile.endTime / duration) * geometry.size.width - 20)
                                .gesture(DragGesture().onChanged { value in
                                    let newEnd = Double(value.location.x) / geometry.size.width * duration
                                    audioFile.endTime = min(duration, max(newEnd, audioFile.startTime + 1))
                                })
                        }
                    }
                }
                .frame(height: 50)
                .padding()
                
                VStack {
                    //                    Button(action: {
                    //                        if isPlaying {
                    //                            audioPlayer?.pause()
                    //                        } else {
                    //                            playAudio()
                    //                        }
                    //                        isPlaying.toggle()
                    //                    }) {
                    //                        Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    //                            .font(.title)
                    //                            .foregroundColor(.blue)
                    //                    }
                    
                    Button("Save") {
                        Task {
                            await saveAudio()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding() // 添加内边距
                    .background( Color.blue) // 设置背景颜色，发送中时为灰色
                    .foregroundColor(.white) // 设置文本颜色为白色
                    .cornerRadius(10) // 设置圆角
                    .shadow(radius: 5) // 设置阴影
                    .padding(.horizontal) // 水平方向的内边距
                }
                .padding()
            }
        }
        .navigationBarTitle("Edit Audio File", displayMode: .inline)
        .onAppear {
            loadAudio()
        }
    }
    
    
    private func validateFileName(_ name: String) {
        
        isNameValid = !name.isEmpty
    }
    
    func loadAudio() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile.url)
            duration = audioPlayer?.duration ?? 0
            audioFile.endTime = duration
            
            
            // Set up a timer to update currentTime
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if isPlaying {
                    currentTime = audioPlayer?.currentTime ?? 0
                }
            }
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    func playAudio() {
        audioPlayer?.currentTime = audioFile.startTime
        audioPlayer?.play()
        
        // Schedule stop
        DispatchQueue.main.asyncAfter(deadline: .now() + audioFile.endTime - audioFile.startTime) {
            audioPlayer?.stop()
            isPlaying = false
        }
    }
    
    
    
    func saveAudio() async {
        audioFile.name = editedName
        
        let asset = AVAsset(url: audioFile.url)
        let composition = AVMutableComposition()
        
        do {
            guard let track = try await asset.loadTracks(withMediaType: .audio).first,
                  let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
                print("Error: Could not create composition track")
                return
            }
            
            
            print(audioFile.startTime,"start time")
            print(audioFile.endTime,"end time")
            
            let startTime = CMTime(seconds: audioFile.startTime, preferredTimescale: 44100)
            let endTime = CMTime(seconds: audioFile.endTime, preferredTimescale: 44100)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            // 使用新的 API 获取原始音频持续时间
            let originalDuration = try await asset.load(.duration)
            print("Original audio duration: \(CMTimeGetSeconds(originalDuration))")
            print("Trimming from \(CMTimeGetSeconds(startTime)) to \(CMTimeGetSeconds(endTime))")
            
            try compositionTrack.insertTimeRange(timeRange, of: track, at: .zero)
            
            print("Composition duration after trim: \(CMTimeGetSeconds(composition.duration))")
            
            guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
                print("Error: Could not create export session")
                return
            }
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let outputURL = documentsPath.appendingPathComponent("\(editedName).m4a")
            
            if FileManager.default.fileExists(atPath: outputURL.path) {
                try? FileManager.default.removeItem(at: outputURL)
            }
            
            export.outputURL = outputURL
            export.outputFileType = .m4a
            export.timeRange = timeRange  // 明确设置导出的时间范围
            
            await export.export()
            
            switch export.status {
            case .completed:
                self.audioFile.url = outputURL
                print("Audio saved successfully at \(outputURL)")
                print("Start Time: \(audioFile.startTime) seconds")
                print("End Time: \(audioFile.endTime) seconds")
                // 使用新的 API 获取导出的音频持续时间
                let exportedAsset = AVAsset(url: outputURL)
                let exportedDuration = try await exportedAsset.load(.duration)
                print("Exported audio duration: \(CMTimeGetSeconds(exportedDuration))")
                
            case .failed, .cancelled:
                print("Export failed: \(String(describing: export.error))")
            default:
                break
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let second = Int(time) % 60
        return String(format: "%02d:%02d", minute, second)
    }
}

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
