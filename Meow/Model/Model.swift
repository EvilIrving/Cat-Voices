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
