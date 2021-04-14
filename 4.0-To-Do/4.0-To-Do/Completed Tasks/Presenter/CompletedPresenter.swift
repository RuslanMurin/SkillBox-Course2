import Foundation
import UIKit

class CompletedPresenter: CompletedPresenterInput {
    var output: CompletedPresenterOutput!
    
    var interactor: CompletedInteractorInput! = CompletedInteractor()
    
    func dataUpdated() {
        interactor.output = self
        output.updateTable(tasks: interactor.requestData())
    }
    
    func rowSelected(indexPath: IndexPath) {
        let output = self.output as! CompletedViewController
        
        output.setupPopover(pop: PopoverViewController(), parent: output, identifier: "CompletedPopover", storyboard: output.storyboard, tableView: output.completedTasksTableView, indexPath: indexPath)
    }
}

protocol CompletedPresenterInput {
    var output: CompletedPresenterOutput! { get set }
    func dataUpdated()
    func rowSelected(indexPath: IndexPath)
}

protocol CompletedPresenterOutput {
    func updateTable(tasks: [TaskModel])
    func setupPopover<T: PopoverViewControllerProtocol>(pop: T, parent: UIViewController, identifier: String, storyboard: UIStoryboard?, tableView: UITableView, indexPath: IndexPath)
}

extension CompletedPresenter: CompletedInteractorOutput {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
