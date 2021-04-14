import Foundation
import RealmSwift

class CompletedInteractor: CompletedInteractorInput {
    
    var output: CompletedInteractorOutput!
    
    let realm = try! Realm()
    
    func requestData() -> [TaskModel] {
        return realm.objects(TaskModel.self)
            .filter(NSPredicate(format: "isCompleted == true"))
            .sorted { $1.created > $0.created }
    }
}

protocol CompletedInteractorInput {
    var output: CompletedInteractorOutput! { get set }
    func requestData() -> [TaskModel]
}

protocol CompletedInteractorOutput {
}
