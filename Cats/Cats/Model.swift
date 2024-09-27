//
//  Model.swift
//  Cats
//
//  Created by Actor on 2024/9/27.
//

import Foundation
import SwiftData

@Model
class Cat {
    @Attribute var name: String
    @Attribute var age: String
    @Attribute var desc: String
//    var sounds:[String]?

    init(name: String, age: String, desc: String) {
        self.name = name
        self.desc = desc
        self.age = age
    }
}
