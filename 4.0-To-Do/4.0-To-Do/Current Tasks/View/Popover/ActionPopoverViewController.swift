import UIKit
import ReactiveKit
import Bond

class ActionPopoverViewController: UIViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    var delegate: CurrentTasksViewController?
    var task: TaskModel?
    let viewModel = CurrentTasksViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeTapped()
        deleteTapped()
    }
    
    func deleteTapped() {
        deleteButton.reactive.tap.observeNext { [self] in
            viewModel.deleteTask(key: task?.key ?? "")
            self.delegate?.viewWillAppear(true)
            self.dismiss(animated: true, completion: nil)
        }
        .dispose(in: reactive.bag)
    }
    
    func completeTapped() {
        completeButton.reactive.tap.observeNext { [self] in
            viewModel.completeTask(key: task?.key ?? "")
            self.delegate?.viewWillAppear(true)
            self.dismiss(animated: true, completion: nil)
        }
        .dispose(in: reactive.bag)
    }
}
