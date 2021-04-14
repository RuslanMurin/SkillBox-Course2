import UIKit
import ReactiveKit
import Bond

class RocketViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    private let pressed = Property((false, false))
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pressed.filter { $0.0 == true && $0.1 == true }
            .replaceElements(with: "Rocket launched")
            .bind(to: label.reactive.text)
        
        firstButton.reactive.tap.observeNext { self.pressed.value.0 = true }
            .dispose(in: reactive.bag)
        secondButton.reactive.tap.observeNext { self.pressed.value.1 = true }
            .dispose(in: reactive.bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reactive.bag.dispose()
    }
}
