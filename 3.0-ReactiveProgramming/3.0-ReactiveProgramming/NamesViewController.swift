import UIKit
import ReactiveKit
import Bond

class NamesViewController: UIViewController {
    
    @IBOutlet weak var namesTableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var names = MutableObservableArray(["Johnatan", "James", "Jake", "Martha", "Alex", "Seth", "Mark", "Ilon", "Anthony", "Steve", "Stan", "Tony", "Michael", "Kirk", "Leonard", "Sheldon", "Hovard", "Joe", "Rose", "Jack"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namesTableview.keyboardDismissMode = .onDrag
        
        names.bind(to: namesTableview) { (dataSourse, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as! NameTableViewCell
            cell.nameLabel.text = dataSourse[indexPath.row]
            return cell
        }
        
        searchBar.reactive.text
            .ignoreNils()
            .filter { $0.count > 0 }
            .throttle(for: 2)
            .observeNext { text in
                self.names.filterCollection { $0.contains(text) }
                    .bind(to: self.namesTableview) { (dataSourse, indexPath, tableView) -> UITableViewCell in
                        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as! NameTableViewCell
                        cell.nameLabel.text = dataSourse[indexPath.row]
                        return cell
                    }
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
