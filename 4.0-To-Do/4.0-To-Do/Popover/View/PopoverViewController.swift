import UIKit
import ReactiveKit
import Bond

protocol PopoverViewControllerProtocol: UIViewController {
    var delegate: CompletedViewController! { get set }
    var task: TaskModel? { get set }
}

class PopoverViewController: UIViewController, PopoverViewControllerProtocol {
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var presenter: PopoverPresenterInput! = PopoverPresenter()
    
    var delegate: CompletedViewController!
    var task: TaskModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deletePressed()
        restorePressed()
    }
    
    func deletePressed() {
        deleteButton.reactive.tap.observeNext { [self] in
            presenter.deleteTapped(withKey: task?.key ?? "")
            delegate.presenter.dataUpdated()
            dismiss(animated: true, completion: nil)
        }
        .dispose(in: reactive.bag)
    }
    
    func restorePressed() {
        restoreButton.reactive.tap.observeNext { [self] in
            presenter.restoreTapped(withKey: task?.key ?? "")
            delegate.presenter.dataUpdated()
            dismiss(animated: true, completion: nil)
        }
        .dispose(in: reactive.bag)
    }
}
