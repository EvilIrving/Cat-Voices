import AVFoundation
import Foundation

/// 音频播放器视图模型类
class AudioPlayerViewModel: ObservableObject {
    @Published var samples: [Float] = []
    @Published var progress: Double = 0
    @Published var isPlaying: Bool = false
    @Published var isLooping: Bool = false

    private var audioPlayer: AVAudioPlayer?
    private var displayLink: CADisplayLink?

    /// 加载音频文件
    /// - Parameter fileName: 音频文件名（不包含扩展名）
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

    /// 切换播放/暂停状态
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

    /// 切换循环播放状态
    func toggleLoop() {
        isLooping.toggle()
        audioPlayer?.numberOfLoops = isLooping ? -1 : 0
    }

    /// 跳转到指定进度
    /// - Parameter percentage: 目标进度（0-1之间的小数）
    func seek(to percentage: Double) {
        guard let audioPlayer = audioPlayer else { return }
        let newTime = percentage * audioPlayer.duration
        audioPlayer.currentTime = newTime
        updateProgress()
    }

    /// 生成波形样本数据
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

    /// 设置显示链接以更新进度
    private func setupDisplayLink() {
        displayLink = CADisplayLink(
            target: self, selector: #selector(updateProgress))
        displayLink?.add(to: .main, forMode: .default)
    }

    /// 停止显示链接
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    deinit {
        stopDisplayLink()
    }

    /// 更新播放进度
    @objc private func updateProgress() {
        guard let audioPlayer = audioPlayer else { return }
        progress = audioPlayer.currentTime / audioPlayer.duration

        if !audioPlayer.isPlaying && progress == 0 && isPlaying {
            isPlaying = false
        }
    }
}
