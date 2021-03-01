import UIKit
import ReactiveKit
import Bond

class RequestViewController: UIViewController {
    
    @IBOutlet weak var requestTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTextfield.reactive.text
            .ignoreNils()
            .filter { $0.count > 0 }
            .debounce(for: 0.5)
            .observeNext {text in
                print("Отправка запроса для \(text)")
            }
            .dispose(in: reactive.bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reactive.bag.dispose()
    }
}
