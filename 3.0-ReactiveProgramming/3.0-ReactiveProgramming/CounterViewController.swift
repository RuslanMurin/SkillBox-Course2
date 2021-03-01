import UIKit
import ReactiveKit
import Bond

class CounterViewController: UIViewController {
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    var counter = Property(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusButton.reactive.tap.with(latestFrom: counter)
            .compactMap { $1 }
            .map { $0 + 1 }
            .bind(to: counter)
        
        counter
            .map { String($0) }
            .bind(to: counterLabel.reactive.text)
    }
}
