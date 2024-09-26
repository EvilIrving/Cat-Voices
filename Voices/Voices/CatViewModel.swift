//
//  Data.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

import SwiftUI

struct Cat: Identifiable {
    var id: UUID
    var name: String
    var sounds: [Sound]
    var description: String
}

// 创建一个 ViewModel 来管理 Cat
class CatViewModel: ObservableObject {
    @Published var cat = Cat(id: UUID(), name: "Whiskers", sounds: [], description: "A friendly feline")

    func editSound(at offset: Array<Sound>.Index, sound: Sound) {
        print(sound.name)
        guard offset >= 0 && offset < cat.sounds.count else {
            print("Invalid offset: \(offset)")
            return
        }

        print("Editing sound at offset \(offset) with new sound: \(sound.name)")
        cat.sounds[offset] = sound
        print("Updated sounds: \(cat.sounds)")
        
    }

    func addSound(sound: Sound) {
        cat.sounds.append(sound)
    }

    func removeSound(at offsets: IndexSet) -> Bool {
        for index in offsets {
            let sound = cat.sounds[index]
            do {
                try FileManager.default.removeItem(at: sound.url)
                cat.sounds.remove(at: index)
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
                return false
            }
        }
        return true
    }
}
