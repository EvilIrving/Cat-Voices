import AVFoundation
import Foundation
import SwiftData

@Model
final class Audio: Identifiable {
    // 使用 @Attribute 注解，表示 id 属性是一个唯一的属性
    @Attribute(.unique) let id: UUID
    var url: URL
    var name: String
    var duration: Double
    var waves: [Float] = []
    var createdAt: Date
<<<<<<< HEAD
    var isLooping: Bool = false

=======
>>>>>>> 4136427b9bc7aa359e4406b62ebec7bfc370ab52
    // 使用 @Relationship 注解，表示 cat 属性是一个反向关联关系，并定义了关联的属性为 Cat 类的 audios 属性
    @Relationship(inverse: \Cat.audios) var cat: Cat?

    // 初始化方法
    init(id: UUID = UUID(), url: URL, name: String) {
        self.id = id
        self.url = url
        self.name = name
        duration = 0.0  // 初始化为 0，稍后会更新
        createdAt = Date()
        isLooping = false
    }

    // 使用 async/await 定义异步方法，用于更新音频时长
    @MainActor
    func updateDuration() async {
        let asset = AVAsset(url: url)
        do {
            let duration = try await asset.load(.duration)
            self.duration = duration.seconds
        } catch {
            print("Error loading audio duration: \(error)")
        }
    }

    @MainActor
    func generateWaves() async {
        var isStale = false
        guard
            let audioFileURL = try? URL(
                resolvingBookmarkData: url.bookmarkData(),
                bookmarkDataIsStale: &isStale)
        else {
            print("无法解析音频文件 URL")
            return
        }

        do {
            let audioFile = try AVAudioFile(forReading: audioFileURL)
            let format = audioFile.processingFormat
            let totalSampleCount = UInt32(audioFile.length)
            let desiredSegmentCount = 20
            let samplesPerSegment = Int(totalSampleCount) / desiredSegmentCount

            guard
                let buffer = AVAudioPCMBuffer(
                    pcmFormat: format, frameCapacity: totalSampleCount)
            else {
                print("无法创建音频缓冲区")
                return
            }
            try audioFile.read(into: buffer)
            guard let floatChannelData = buffer.floatChannelData else {
                print("无法获取浮点通道数据")
                return
            }

            var samples: [Float] = []
            for i in 0..<desiredSegmentCount {
                let startSample = i * samplesPerSegment
                let endSample = min(
                    (i + 1) * samplesPerSegment, Int(totalSampleCount))
                let sum = (startSample..<endSample).reduce(Float(0)) {
                    result, currentSample in
                    let leftChannel = abs(floatChannelData[0][currentSample])
                    let rightChannel =
                        format.channelCount > 1
                        ? abs(floatChannelData[1][currentSample]) : 0
                    return result
                        + ((leftChannel + rightChannel)
                            / Float(format.channelCount))
                }
                samples.append(sum / Float(endSample - startSample))
            }

            self.waves = samples
        } catch {
            print("生成波形时出错：\(error)")
        }
    }
}
