import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let cats: [Cat]
    let events: [Event]
    let weights: [Weight]

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Cat.self, Audio.self, Event.self, configurations: config)

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

        // 创建示例体重数据
        let weight1 = Weight(date: defaultDate, cat: cat1, weightInKg: 4.5)
        let weight2 = Weight(date: defaultDate, cat: cat2, weightInKg: 5.0)
        let weight3 = Weight(date: defaultDate, cat: cat3, weightInKg: 3.8)

        // 将体重数据保存到容器中
        container.mainContext.insert(weight1)
        container.mainContext.insert(weight2)
        container.mainContext.insert(weight3)

        // 体重数据数组
        weights = [weight1, weight2, weight3]

        // 创建默认事件
        let event1 = Event(eventType: .bath, cat: cats[0], reminderDate: Date().addingTimeInterval(86400), reminderTime: Date(), repeatInterval: .weekly, notes: "使用猫咪专用洗发水")
        let event2 = Event(eventType: .doctorVisit, cat: cats[1], reminderDate: Date().addingTimeInterval(7 * 86400), reminderTime: Date(), repeatInterval: .monthly, notes: "带上疫苗本")
        let event3 = Event(eventType: .feeding, cat: cats[2], reminderDate: Date().addingTimeInterval(3 * 86400), reminderTime: Date(), repeatInterval: .daily, notes: "使用新购买的猫粮")

        // 将事件保存到容器中
        container.mainContext.insert(event1!)
        container.mainContext.insert(event2!)
        container.mainContext.insert(event3!)

        events = [event1!, event2!, event3!]
    }
}
