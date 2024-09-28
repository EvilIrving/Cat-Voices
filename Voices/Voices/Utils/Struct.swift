//
//  Struct.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//
 
import AVFoundation
import CoreAudio
 
struct Sound: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var urlString: String
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var duration: TimeInterval?

    // 使用 URL 字符串来满足 Codable
    enum CodingKeys: String, CodingKey {
        case id, name, urlString, startTime, endTime, duration
    }

    // 自定义初始化方法
    init(name: String, url: URL) {
        self.name = name
        self.urlString = url.absoluteString
        self.id = UUID()
    }

    // 解码器初始化方法
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        urlString = try container.decode(String.self, forKey: .urlString)
        startTime = try container.decodeIfPresent(TimeInterval.self, forKey: .startTime) ?? 0
        endTime = try container.decodeIfPresent(TimeInterval.self, forKey: .endTime) ?? 0
        duration = try container.decodeIfPresent(TimeInterval.self, forKey: .duration)
    }

    // 编码方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(urlString, forKey: .urlString)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encodeIfPresent(duration, forKey: .duration)
    }

    // 遵循 Hashable 协议
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
