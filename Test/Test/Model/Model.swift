import SwiftData
import Foundation
import AVFoundation


// MARK: - Cat Model

@Model
final class Cat: Identifiable {
    // 使用 @Attribute 注解，表示 id 属性是一个唯一的属性
    @Attribute(.unique) let id: UUID
    var name: String
    var age: String
    var desc: String
    var avatar: URL?
    var nickname: String?
    var gender: Gender
    var birthday: Date?
    var weight: Double?
    var bodyType: BodyType
    // 使用 @Relationship 注解，表示 audios 属性是一个关联关系，并定义了删除规则为级联删除
    @Relationship(deleteRule: .cascade) var audios: [Audio] = []

    // 初始化方法
    init(id: UUID = UUID(), name: String, age: String, desc: String, gender: Gender, bodyType: BodyType) {
        self.id = id
        self.name = name
        self.age = age
        self.desc = desc
        self.gender = gender
        self.bodyType = bodyType
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

// MARK: - Audio Model

@Model
final class Audio: Identifiable {
    // 使用 @Attribute 注解，表示 id 属性是一个唯一的属性
    @Attribute(.unique) let id: UUID
    var url: URL
    var name: String
    var duration: Double

    // 使用 @Relationship 注解，表示 cat 属性是一个反向关联关系，并定义了关联的属性为 Cat 类的 audios 属性
    @Relationship(inverse: \Cat.audios) var cat: Cat?

    // 初始化方法
    init(id: UUID = UUID(), url: URL, name: String) {
        self.id = id
        self.url = url
        self.name = name
        self.duration = 0.0 // 初始化为 0，稍后会更新
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
}

// MARK: - Enums

enum Gender: String, CaseIterable, Codable { // 使用 CaseIterable
    case male = "Male"
    case female = "Female"
    case unknown = "Unknown"
}

enum BodyType: String,CaseIterable, Codable {
     
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
}
