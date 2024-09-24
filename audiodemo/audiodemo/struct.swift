//
//  struct.swift
//  audiodemo
//
//  Created by Actor on 2024/9/23.
//

import AVFoundation

struct AudioFile: Identifiable {
    let id = UUID()
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
}
