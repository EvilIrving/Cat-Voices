//
//  Struct.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//
// 定义的结构体
import AVFoundation

// Model for Cat
struct Cat: Identifiable {
    var id: UUID
    var name: String
    var sounds: [Sound]
    var description: String
}

// Model for Sound

struct Sound: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var url: URL
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var duration: TimeInterval? // 总时长

    // 自定义初始化方法
    init(name: String, url: URL) {
        self.name = name
        self.url = url

        print("Audio File \(name) Init")

        // 初始化 AVAudioPlayer 并获取音频时长
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            duration = player.duration
            endTime = player.duration // 初始时，endTime 即为文件的时长
        } catch {
            print("Error initializing AVAudioPlayer: \(error)")
            duration = nil
        }
    }

    // Implement equality based on id
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.id == rhs.id
    }
}
