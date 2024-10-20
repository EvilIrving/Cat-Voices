import AVFoundation
import Foundation

class AudioPlayerViewModel: NSObject, ObservableObject {
    @Published var samples: [Float] = []
    @Published var progress: Double = 0
    @Published var isPlaying: Bool = false
    @Published var isLooping: Bool = false {
        didSet {
            updateLoopingState()
        }
    }
    @Published var currentAudioURL: URL?
    @Published var audioFileName: String = ""
    @Published var duration: TimeInterval = 0
    @Published var currentTime: TimeInterval = 0

    private var audioPlayer: AVAudioPlayer?
    private var displayLink: CADisplayLink?

    override init() {
        super.init()
    }

    private func updateLoopingState() {
        if let audioPlayer = audioPlayer {
            if isLooping {
                audioPlayer.numberOfLoops = -1 // 无限循环
            } else {
                audioPlayer.numberOfLoops = 0 // 不循环
                // 如果当前播放位置已经超过了总时长的99%，则立即停止播放
                if audioPlayer.currentTime > audioPlayer.duration * 0.99 {
                    pause()
                    audioPlayer.currentTime = 0
                    isPlaying = false
                    progress = 0
                    currentTime = 0
                    pauseDisplayLink()
                }
            }
        }
    }

    func setLooping(_ looping: Bool) {
        isLooping = looping
    }

    func loadAudio(url: URL, isLooping: Bool) throws {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            setLooping(isLooping)

            self.currentAudioURL = url
            self.audioFileName = url.deletingPathExtension().lastPathComponent

            if let audioPlayer = audioPlayer, audioPlayer.prepareToPlay() {
                print("音频文件成功加载并准备播放")
                generateWaveformSamples()
                duration = audioPlayer.duration
                isPlaying = false
            } else {
                print("准备播放失败，可能是文件损坏")
            }
        } catch {
            print("加载音频失败: \(error.localizedDescription)")
            throw error
        }
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func play() {
        if audioPlayer == nil, let url = currentAudioURL {
            do {
                try loadAudio(url: url, isLooping: isLooping)
            } catch {
                print("重新加载音频失败: \(error.localizedDescription)")
                return
            }
        }
        audioPlayer?.play()
        isPlaying = true
        setupDisplayLink()
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        pauseDisplayLink()
    }

    func toggleLoop() {
        isLooping.toggle()
        audioPlayer?.numberOfLoops = isLooping ? -1 : 0
    }

    func seek(to percentage: Double) {
        guard let audioPlayer = audioPlayer else { return }
        let newTime = percentage * audioPlayer.duration
        audioPlayer.currentTime = newTime
        updateProgress()
    }

    private func generateWaveformSamples() {
        guard let audioPlayer: AVAudioPlayer = audioPlayer,
            let url = audioPlayer.url
        else { return }

        do {
            let audioFile = try AVAudioFile(forReading: url)
            let format = audioFile.processingFormat
            let totalSampleCount = UInt32(audioFile.length)
            let desiredSegmentCount = 33
            let samplesPerSegment = Int(totalSampleCount) / desiredSegmentCount

            guard
                let buffer = AVAudioPCMBuffer(
                    pcmFormat: format, frameCapacity: totalSampleCount)
            else { return }
            try audioFile.read(into: buffer)
            guard let floatChannelData = buffer.floatChannelData else { return }

            var samples: [Float] = []
            for i in 0..<desiredSegmentCount {
                let startSample = i * samplesPerSegment
                let endSample = min(
                    (i + 1) * samplesPerSegment, Int(totalSampleCount))
                let sum = (startSample..<endSample).reduce(Float(0)) {
                    result, currentSample in
                    let leftChannel = abs(floatChannelData[0][currentSample])
                    let rightChannel = abs(floatChannelData[1][currentSample])
                    return result + ((leftChannel + rightChannel) / 2)
                }
                samples.append(sum / Float(endSample - startSample))
            }

            DispatchQueue.main.async {
                self.samples = samples
            }
        } catch {
            print("生成波形时出错：\(error)")
        }
    }

    private func setupDisplayLink() {
        #if os(iOS)
            if displayLink == nil {
                displayLink = CADisplayLink(
                    target: self, selector: #selector(updateProgress))
                displayLink?.add(to: .main, forMode: .default)
            }
            displayLink?.isPaused = false
        #else
            // 对于macOS，使用Timer替代CADisplayLink
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {
                [weak self] _ in
                self?.updateProgress()
            }
        #endif
    }

    private func pauseDisplayLink() {
        #if os(iOS)
            displayLink?.isPaused = true
        #endif
    }

    @objc private func updateProgress() {
        guard let audioPlayer = audioPlayer else { return }
        progress = audioPlayer.currentTime / audioPlayer.duration
        currentTime = audioPlayer.currentTime

        // 检查是否接近结束且不循环
        if !isLooping && progress > 0.99 {
            isPlaying = false
            pauseDisplayLink()
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            progress = 0
            currentTime = 0
        }
    }

    deinit {
        audioPlayer?.stop()
        audioPlayer = nil
        displayLink?.invalidate()
        displayLink = nil
    }
}

extension AudioPlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            if self.isLooping {
                self.play()
            } else {
                self.isPlaying = false
                self.progress = 0
                self.currentTime = 0
                self.pauseDisplayLink()
            }
        }
    }
}