import UIKit

class NumbersViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    private let queue = TestQueue()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
    }
    
    // MARK: - Нажатие Return на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let number = Int(self.textField.text ?? "") else { return false }
        
        DispatchQueue.global(qos: .background).async {
            let start = CFAbsoluteTimeGetCurrent()
            for n in 0...number {
                if n.isPrime { print(n) }
            }
            print("Выполнено за \(CFAbsoluteTimeGetCurrent() - start) сек.")
        }
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func addOperationTouchedUp() {
        queue.add()
    }
}

// MARK: - Проверка на простое число
extension Int {
    var isPrime: Bool {
        guard self >= 2 else { return false }
        guard self != 2 else { return true  }
        guard self % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
    }
}
// MARK: - Класс с очередями
class TestQueue {
    var queue = OperationQueue()
    
    func add() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.queue.addOperation { MainOperation().run() }
        }
    }
}

class MainOperation: Operation {
    func run() {
        guard !isCancelled else {
            cancel()
            return
        }
            print("cancelled")
            cancel()
    }
}
