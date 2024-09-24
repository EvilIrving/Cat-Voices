import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var dateTimer: Date?

    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var recordingURL: URL?

    override init() {
        super.init()
        setupAudioSession()
    }

    // Setup audio session
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    // Start recording
    func startRecording() {
        guard !isRecording else { return }

        isRecording = true
        updateButtonDetails()

        timerStart()

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2
        ]

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = paths[0].appendingPathComponent("recording.m4a")
        recordingURL = fileURL

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            print("Started recording at \(fileURL.path)")
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    // Stop recording
    func stopRecording() {
        guard isRecording else { return }

        isRecording = false
        updateButtonDetails()

        timerStop()
        
        audioRecorder?.stop()
        print("Stopped recording at \(recordingURL?.path ?? "Unknown path")")
        audioRecorder = nil
    }

    // Start playback
    func startPlaying() {
        guard let url = recordingURL, !isPlaying else { return }

        isPlaying = true
        updateButtonDetails()

        timerStart()

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Started playing sound from \(url.path)")
        } catch {
            print("Failed to start playing: \(error.localizedDescription)")
        }
    }

    // Stop playback
    func stopPlaying() {
        guard isPlaying else { return }

        isPlaying = false
        updateButtonDetails()

        timerStop()

        audioPlayer?.stop()
        print("Stopped playing sound")
        audioPlayer = nil
    }

    // Update button details
    private func updateButtonDetails() {
        // Implement UI update logic here
    }

    // Timer methods
    private func timerStart() {
        dateTimer = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { _ in
            self.timerUpdate()
        }
    }

    private func timerUpdate() {
        if let dateTimer = dateTimer {
            let interval = Date().timeIntervalSince(dateTimer)
            let millisec = Int(interval * 100) % 100
            let seconds = Int(interval) % 60
            let minutes = Int(interval) / 60
            // Update timer label here
            print(String(format: "%02d:%02d:%02d", minutes, seconds, millisec))
        }
    }

    private func timerStop() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioRecorder: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        updateButtonDetails()
        timerStop()
    }
}
