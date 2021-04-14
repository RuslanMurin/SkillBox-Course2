import UIKit
import ReactiveKit
import Bond
import RealmSwift

class AddingViewController: UIViewController {
    
    private let realm = try? Realm()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descrTextField: UITextField!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        descrTextField.delegate = self
        
        addButton.reactive.tap.observeNext { [self] in
            guard titleTextField.text != "" && descrTextField.text != "" else { return }
            
            let task = TaskModel()
            task.title = titleTextField.text ?? "None"
            task.descr = descrTextField.text ?? "None"
            task.deadline = deadlineDatePicker.date
            
            try? realm?.write { [self] in
                realm?.add(task, update: .modified)
            }
        }
        .dispose(in: reactive.bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AddingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

