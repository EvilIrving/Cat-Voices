import SwiftData
import Foundation

@MainActor
struct Previewer {
    let container: ModelContainer
    let cats: [Cat]
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Cat.self, Audio.self, configurations: config)
        
        // 创建一个日期格式化器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let defaultDate = dateFormatter.date(from: "2022-03-17")!
        
        // 创建示例猫咪
        let cat1 = Cat(name: "咪咪", breed: .americanShorthair, birthDate: defaultDate, adoptionDate: defaultDate, gender: .female, neuteringStatus: .neutered, currentStatus: .present)
        let cat2 = Cat(name: "花花", breed: .britishShorthair, birthDate: defaultDate, adoptionDate: defaultDate, gender: .male, neuteringStatus: .notNeutered, currentStatus: .present)
        let cat3 = Cat(name: "小黑", breed: .other, birthDate: defaultDate, adoptionDate: defaultDate, gender: .male, neuteringStatus: .neutered, currentStatus: .absent)

        // 将猫咪保存到容器中
        container.mainContext.insert(cat1)
        container.mainContext.insert(cat2)
        container.mainContext.insert(cat3)
        
        cats = [cat1, cat2, cat3]
    }
}
