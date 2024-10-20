import AVFoundation
import Foundation
import SwiftData

// MARK: - Cat Model

import AVFoundation
import Foundation
import SwiftData

// MARK: - Cat Model

@Model
final class Cat: Identifiable {
    // 使用 @Attribute 注解，表示 id 属性是一个唯一的属性
    @Attribute(.unique) let id: UUID
    var name: String
    var avatar: URL?
    var breed: Breed
    var birthDate: Date?
    var adoptionDate: Date?
    var gender: Gender
    var neuteringStatus: NeuteringStatus
    var currentStatus: CurrentStatus
    // 使用 @Relationship 注解，表示 audios 属性是一个关联关系，并定义了删除规则为级联删除
    @Relationship(deleteRule: .cascade) var audios: [Audio] = []
    // 添加与 Event 的关系
    @Relationship(deleteRule: .cascade) var events: [Event] = []
    // 体重
    @Relationship(deleteRule: .cascade) var weights: [Weight] = []

    var sortedAudios: [Audio] {
        return audios.sorted { $0.createdAt < $1.createdAt }
    }

    // 初始化方法
    init(id: UUID = UUID(), name: String, avatar: URL? = nil, breed: Breed, birthDate: Date? = nil, adoptionDate: Date? = nil, gender: Gender, neuteringStatus: NeuteringStatus, currentStatus: CurrentStatus) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.breed = breed
        self.birthDate = birthDate
        self.adoptionDate = adoptionDate
        self.gender = gender
        self.neuteringStatus = neuteringStatus
        self.currentStatus = currentStatus
    }
}

// MARK: - Cat Extensions

extension Cat {
    func addAudio(_ audio: Audio) {
        audios.append(audio)
        audio.cat = self
    }

    func removeAudio(_ audio: Audio) {
        audios.removeAll { $0.id == audio.id }
        audio.cat = nil
    }
}

// MARK: - Enums

enum Breed: String, CaseIterable, Codable {
    case ragdoll = "布偶"
    case britishShorthair = "英短"
    case americanShorthair = "美短"
    case siamese = "暹罗"
    case maineCoon = "缅因"
    case other = "其他"
}

enum Gender: String, CaseIterable, Codable {
    case male = "GG"
    case female = "MM"
}

enum NeuteringStatus: String, CaseIterable, Codable {
    case neutered = "已绝育"
    case notNeutered = "未绝育"
    case unknown = "未知"
}

enum CurrentStatus: String, CaseIterable, Codable {
    case present = "在身边"
    case absent = "在喵星生活"
}

//// MARK: - Audio Model
//
//@Model
//final class Audio: Identifiable {
//    // 使用 @Attribute 注解，表示 id 属性是一个唯一的属性
//    @Attribute(.unique) let id: UUID
//    var url: URL
//    var name: String
//    var duration: Double
//    var waves: [Float] = []
//
//    // 使用 @Relationship 注解，表示 cat 属性是一个反向关联关系，并定义了关联的属性为 Cat 类的 audios 属性
//    @Relationship(inverse: \Cat.audios) var cat: Cat?
//
//    // 初始化方法
//    init(id: UUID = UUID(), url: URL, name: String) {
//        self.id = id
//        self.url = url
//        self.name = name
//        duration = 0.0 // 初始化为 0，稍后会更新
//    }
//
//    // 使用 async/await 定义异步方法，用于更新音频时长
//    @MainActor
//    func updateDuration() async {
//        let asset = AVAsset(url: url)
//        do {
//            let duration = try await asset.load(.duration)
//            self.duration = duration.seconds
//        } catch {
//            print("Error loading audio duration: \(error)")
//        }
//    }
//
//    @MainActor
//    func generateWaves() async {
//        var isStale = false
//        guard let audioFileURL = try? URL(resolvingBookmarkData: url.bookmarkData(), bookmarkDataIsStale: &isStale) else {
//            print("无法解析音频文件 URL")
//            return
//        }
//
//        do {
//            let audioFile = try AVAudioFile(forReading: audioFileURL)
//            let format = audioFile.processingFormat
//            let totalSampleCount = UInt32(audioFile.length)
//            let desiredSegmentCount = 33
//            let samplesPerSegment = Int(totalSampleCount) / desiredSegmentCount
//
//            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: totalSampleCount) else {
//                print("无法创建音频缓冲区")
//                return
//            }
//            try audioFile.read(into: buffer)
//            guard let floatChannelData = buffer.floatChannelData else {
//                print("无法获取浮点通道数据")
//                return
//            }
//
//            var samples: [Float] = []
//            for i in 0..<desiredSegmentCount {
//                let startSample = i * samplesPerSegment
//                let endSample = min((i + 1) * samplesPerSegment, Int(totalSampleCount))
//                let sum = (startSample..<endSample).reduce(Float(0)) { result, currentSample in
//                    let leftChannel = abs(floatChannelData[0][currentSample])
//                    let rightChannel = format.channelCount > 1 ? abs(floatChannelData[1][currentSample]) : 0
//                    return result + ((leftChannel + rightChannel) / Float(format.channelCount))
//                }
//                samples.append(sum / Float(endSample - startSample))
//            }
//
//            self.waves = samples
//        } catch {
//            print("生成波形时出错：\(error)")
//        }
//    }
//}

// MARK: - Enums

enum BodyType: String, CaseIterable, Codable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
}

// MARK: - Weight Model

@Model
final class Weight: Identifiable {
    @Attribute(.unique) let id: UUID
    var date: Date
    var cat: Cat
    var weightInKg: Double // 以千克为单位存储体重

    var formattedWeightInKg: String {
        return String(format: "%.2f", weightInKg) // 读取时保留小数点后 2 位
    }

    // 初始化方法
    init(id: UUID = UUID(), date: Date, cat: Cat, weightInKg: Double) {
        self.id = id
        self.date = date
        self.cat = cat
        self.weightInKg = weightInKg
    }
}
