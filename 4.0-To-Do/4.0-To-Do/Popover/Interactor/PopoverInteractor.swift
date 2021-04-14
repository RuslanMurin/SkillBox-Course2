import Foundation
import RealmSwift

class PopoverInteractor: PopoverInteractorInput {
    
    private let realm = try! Realm()
    
    func deleteTask(withKey: String) {
        if let object = realm.object(ofType: TaskModel.self, forPrimaryKey: withKey) {
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    func restoreTask(withKey: String) {
        if let object = realm.object(ofType: TaskModel.self, forPrimaryKey: withKey) {
            try! realm.write {
                object.isCompleted = false
            }
        }
    }
}

protocol PopoverInteractorInput {
    func deleteTask(withKey: String)
    func restoreTask(withKey: String)
}
