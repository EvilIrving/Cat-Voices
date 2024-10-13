import AVFoundation
import Foundation

class AudioPlayerViewModel: ObservableObject {
    @Published var samples: [Float] = []
    @Published var progress: Double = 0
    @Published var isPlaying: Bool = false
    @Published var isLooping: Bool = false

    private var audioPlayer: AVAudioPlayer?
    private var displayLink: CADisplayLink?

    func loadAudio(fileName: String) {
        guard
            let url = Bundle.main.url(
                forResource: fileName, withExtension: "mp3")
        else {
            print("无法找到音频文件: \(fileName).mp3")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()

            if let audioPlayer = audioPlayer, audioPlayer.prepareToPlay() {
                print("音频文件成功加载并准备播放")
                generateWaveformSamples()
            } else {
                print("准备播放失败，可能是文件损坏")
            }
        } catch {
            print("加载音频时出错: \(error)")
        }
    }

    func togglePlayPause() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
            if displayLink == nil {
                setupDisplayLink()
            }
        }
        isPlaying.toggle()
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
        displayLink = CADisplayLink(
            target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .default)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    deinit {
        stopDisplayLink()
    }

    @objc private func updateProgress() {
        guard let audioPlayer = audioPlayer else { return }
        progress = audioPlayer.currentTime / audioPlayer.duration

        if !audioPlayer.isPlaying && progress == 0 && isPlaying {
            isPlaying = false
        }
    }
}
