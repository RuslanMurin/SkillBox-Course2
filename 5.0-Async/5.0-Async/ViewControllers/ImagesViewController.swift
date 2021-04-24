import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
