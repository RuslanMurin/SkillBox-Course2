import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    // MARK: - Загрузка
    @IBAction func loadTouchedUp() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let url = URL(string: "https://wallpaperaccess.com/full/3904051.jpg")!
            let data = try! Data(contentsOf: url)
            DispatchQueue.main.async { [weak self] in
                self?.firstImageView.image = UIImage(data: data)
            }
        }
    }
    // MARK: - Размытие
    @IBAction func blurTouchedUp() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let url = URL(string: "https://wallpaperaccess.com/full/2029165.jpg")!
            let data = try! Data(contentsOf: url)
            if let ciImg = CIImage(image: UIImage(data: data)!)?.applyingFilter("CIGaussianBlur") {
                DispatchQueue.main.async { [weak self] in
                    self?.secondImageView.image = UIImage(ciImage: ciImg)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: - Нажатие Return на клавиатуре
extension ImagesViewController: UITextFieldDelegate {
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
