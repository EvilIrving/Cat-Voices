import SwiftData
import Foundation

@Model
class Cat {
    var id: String = UUID().uuidString
    var name: String
    var age: String
    var desc: String
    // 头像 昵称 性别 生日 体重 体型
    var audios: [Sound] = []

    init(name: String, age: String, desc: String) {
        self.name = name
        self.age = age
        self.desc = desc
    }
}
