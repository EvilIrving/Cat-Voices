//
//  Struct.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//
// 定义的结构体
import Foundation


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
    var URL: URL
    
    // Implement equality based on id
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.id == rhs.id
    }
}
