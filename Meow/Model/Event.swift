import Foundation
import SwiftData

@Model
final class Event: Identifiable {
    @Attribute(.unique) let id: UUID
    var eventType: EventType
    @Relationship(inverse: \Cat.events) var cat: Cat
    var reminderDate: Date
    var reminderTime: Date
    var repeatInterval: RepeatInterval
    var notes: String?

    init(id: UUID = UUID(), eventType: EventType, cat: Cat, reminderDate: Date, reminderTime: Date, repeatInterval: RepeatInterval, notes: String? = nil) {
        // 校验
//        let validationResult = validate(eventType: eventType, cat: cat, reminderDate: reminderDate, reminderTime: reminderTime, repeatInterval: repeatInterval)
//        if !validationResult.isValid {
//            print("校验失败: \(validationResult.missingFields.joined(separator: ", "))")
//            return nil // 初始化失败
//        }

        self.id = id
        self.eventType = eventType
        self.cat = cat
        self.reminderDate = reminderDate
        self.reminderTime = reminderTime
        self.repeatInterval = repeatInterval
        self.notes = notes
    }

    enum EventType: Hashable, CaseIterable, Codable {
        case custom(String)
        case bath
        case litterBox
        case feeding
        case outing
        case doctorVisit
        case healthCheck
        case surgery

        static var allCases: [EventType] {
            var cases: [EventType] = [.bath, .litterBox, .feeding, .outing, .doctorVisit, .healthCheck, .surgery]
            cases.insert(contentsOf: customTypes.map { .custom($0) }, at: 0)
            return cases
        }

        static var customTypes: [String] = []

        var description: String {
            switch self {
            case let .custom(type): return type
            case .bath: return "洗澡"
            case .litterBox: return "铲屎"
            case .feeding: return "喂奶"
            case .outing: return "出门玩"
            case .doctorVisit: return "看医生"
            case .healthCheck: return "体检"
            case .surgery: return "手术"
            }
        }

        static func addCustomType(_ type: String) {
            if !customTypes.contains(type) {
                customTypes.insert(type, at: 0)
            }
        }
    }

    enum RepeatInterval: String, CaseIterable, Codable {
        case daily = "每天"
        case threeDay = "每三天"
        case weekly = "每周"
        case biweekly = "每两周"
        case threeWeekly = "每三周"
        case monthly = "每月"
        case bimonthly = "每两月"
        case quarterly = "每三月"
        case yearly = "每年"

        var description: String {
            return rawValue
        }
    }
 
}
