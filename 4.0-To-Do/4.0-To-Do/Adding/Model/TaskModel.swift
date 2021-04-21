import Foundation
import RealmSwift

enum TaskStatus: String {
    case created = "created"
    case deleted = "deleted"
    case completed = "completed"
}

class TaskModel: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var descr = ""
    @objc dynamic var created = Date()
    @objc dynamic var deadline = Date()
    @objc dynamic var key = UUID().uuidString
    @objc dynamic var isCompleted = false
    
    public override static func primaryKey() -> String? {
        return "key"
    }
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: self)
    }
}
