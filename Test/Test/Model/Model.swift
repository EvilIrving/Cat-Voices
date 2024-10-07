import SwiftData
import Foundation
import AVFoundation


// 定义 Cat 类，使用 @Model 注解，表示它是一个 SwiftData 模型
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

// 定义 Gender 枚举类型，使用 Codable 注解，表示它可以被编码和解码
enum Gender: String, CaseIterable, Codable { // 使用 CaseIterable
    case male = "Male"
    case female = "Female"
    case unknown = "Unknown"
}

// 定义 BodyType 枚举类型，使用 Codable 注解，表示它可以被编码和解码
enum BodyType: String,CaseIterable, Codable {
     
    case small = "Small"
    case medium = "Meduim"
    case large = "Large"
}

// 定义 Audio 类，使用 @Model 注解，表示它是一个 SwiftData 模型
@Model
final class Audio {
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
        duration = 0.0 // 初始化为 0，稍后会更新
    }

    // 使用 async/await 定义异步方法，用于更新音频时长
    func updateDuration() async {
        let asset = AVAsset(url: url)
        do {
            let duration = try await asset.load(.duration)
            await MainActor.run {
                self.duration = duration.seconds
            }
        } catch {
            print("Error loading audio duration: \(error)")
        }
    }
}

extension Cat {
    func addAudio(_ audio: Audio) {
        audios.append(audio)
        audio.cat = self
    }

    func removeAudio(_ audio: Audio) {
        if let index = audios.firstIndex(where: { $0.id == audio.id }) {
            audios.remove(at: index)
            audio.cat = nil
        }
    }
}
