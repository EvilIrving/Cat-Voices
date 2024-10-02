import Foundation
import SwiftData

@Model
final class Cat {
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
    @Relationship(deleteRule: .cascade) var audios: [Audio] = []

    init(id: UUID = UUID(), name: String, age: String, desc: String, gender: Gender, bodyType: BodyType) {
        self.id = id
        self.name = name
        self.age = age
        self.desc = desc
        self.gender = gender
        self.bodyType = bodyType
    }
}

enum Gender: String, Codable {
    case male, female, unknown
}

enum BodyType: String, Codable {
    case small, medium, large
}

@Model
final class Audio {
    @Attribute(.unique) let id: UUID
    let url: URL
    let name: String
    let duration: TimeInterval
    
    @Relationship(inverse: \Cat.audios) var cat: Cat?

    init(id: UUID = UUID(), url: URL, name: String, duration: TimeInterval) {
        self.id = id
        self.url = url
        self.name = name
        self.duration = duration
    }
}

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
