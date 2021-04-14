import Foundation
import ReactiveKit
import Bond
import RealmSwift

class CurrentTasksViewModel {
    
    static let shared = CurrentTasksViewModel()
    private let realm = try! Realm()
    
    var tasks = MutableObservableArray(Array(try! Realm().objects(TaskModel.self)
                                                .filter(NSPredicate(format: "isCompleted == false")))
                                        .sorted { $1.created > $0.created })
                                                
    func deleteTask(key: String) {
        if let object = realm.object(ofType: TaskModel.self, forPrimaryKey: key) {
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    func completeTask(key: String) {
        if let object = realm.object(ofType: TaskModel.self, forPrimaryKey: key) {
            try! realm.write {
                object.isCompleted = true
            }
        }
    }
    
    func restoreTask(key: String) {
        if let object = realm.object(ofType: TaskModel.self, forPrimaryKey: key) {
            try! realm.write {
                object.isCompleted = false
            }
        }
    }
}
