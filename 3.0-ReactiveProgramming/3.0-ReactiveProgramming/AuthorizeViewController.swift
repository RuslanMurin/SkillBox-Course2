import UIKit
import ReactiveKit
import Bond

class AuthorizeViewController: UIViewController {
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = Property((false, false))
        
        mailTextfield.reactive.text
            .ignoreNils()
            .filter { $0.count > 0 }
            .map { $0.isValidEmail() ? "" : "Некорректная почта" }
            .bind(to: errorLabel.reactive.text)
        
        passwordTextfield.reactive.text
            .ignoreNils()
            .filter { $0.count > 0}
            .map { $0.count < 6 ? "Пароль слишком короткий" : "" }
            .bind(to: errorLabel.reactive.text)
        
        status
            .filter { $0.0 == true && $0.1 == true }
            .replaceElements(with: true)
            .bind(to: joinButton.reactive.isEnabled)
        
    }
}
