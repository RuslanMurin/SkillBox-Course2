import Foundation

class PopoverPresenter: PopoverPresenterInput {
    
    var interactor: PopoverInteractorInput! = PopoverInteractor()
    
    func deleteTapped(withKey: String) {
        interactor.deleteTask(withKey: withKey)
    }
    
    func restoreTapped(withKey: String) {
        interactor.restoreTask(withKey: withKey)
    }
}

protocol PopoverPresenterInput {
    func deleteTapped(withKey: String)
    func restoreTapped(withKey: String)
}
