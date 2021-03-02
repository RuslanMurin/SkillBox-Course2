import UIKit
import ReactiveKit
import Bond

class NamesViewController: UIViewController {
    
    @IBOutlet weak var namesTableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var names = MutableObservableArray(["Johnatan", "James", "Jake", "Martha", "Alex", "Seth", "Mark", "Ilon", "Anthony", "Steve", "Stan", "Tony", "Michael", "Kirk", "Leonard", "Sheldon", "Hovard", "Joe", "Rose", "Jack"])
    let filteredNames = MutableObservableArray<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namesTableview.keyboardDismissMode = .onDrag
        
        filteredNames.bind(to: namesTableview) { (dataSourse, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as! NameTableViewCell
            cell.nameLabel.text = dataSourse[indexPath.row]
            return cell
        }
        
        searchBar.reactive.text
            .ignoreNils()
            .removeDuplicates()
            .throttle(for: 2)
            .observeNext { [self] text in
                text.count > 0
                    ? self.names.filterCollection { $0.contains(text) }.bind(to: filteredNames)
                    : self.names.bind(to: filteredNames)
            }
            .dispose(in: reactive.bag)
    }
    
    @IBAction func addPressed() {
        names.insert(names.array.randomElement() ?? "Ruslan", at: 0)
    }
    
    @IBAction func deletePressed() {
        guard !names.isEmpty else { return }
        names.removeLast()
    }
    override func viewWillDisappear(_ animated: Bool) {
        reactive.bag.dispose()
    }
}
