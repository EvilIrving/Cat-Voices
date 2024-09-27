import SwiftData

@Model
class Cat {
     var name: String
     var age: Int
     var vaccinationData: String
     var audioFiles: [Sound]
    
    init(name: String, age: Int, vaccinationData: String, audioFiles: [Sound]) {
        self.name = name
        self.age = age
        self.vaccinationData = vaccinationData
        self.audioFiles = audioFiles
    }
}
 
