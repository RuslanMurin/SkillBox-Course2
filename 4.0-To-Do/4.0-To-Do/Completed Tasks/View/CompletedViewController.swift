import UIKit
import ReactiveKit
import Bond

class CompletedViewController: UIViewController {
    @IBOutlet weak var completedTasksTableView: UITableView!
    
    var presenter: CompletedPresenterInput! = CompletedPresenter()
    var tasks: [TaskModel]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.output = self
        presenter.dataUpdated()
        
        completedTasksTableView.reactive.selectedRowIndexPath.observeNext { indexPath in
            self.presenter.rowSelected(indexPath: indexPath)
        }
        .dispose(in: reactive.bag)
    }
}

extension CompletedViewController: CompletedPresenterOutput {
    func setupPopover<T: PopoverViewControllerProtocol>(pop: T, parent: UIViewController, identifier: String, storyboard: UIStoryboard?, tableView: UITableView, indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        guard let popover = storyboard?.instantiateViewController(withIdentifier: identifier) as? T else { return }
        popover.modalPresentationStyle = .popover
        popover.delegate = parent as? CompletedViewController
        popover.task = self.tasks?[indexPath.row]
        popover.preferredContentSize = CGSize(width: 100, height: 150)
        weak var popVC = popover.popoverPresentationController
        popVC?.delegate = parent as? UIPopoverPresentationControllerDelegate
        popVC?.sourceView = cell
        popVC?.sourceRect = CGRect(x: cell?.bounds.midX ?? 50, y: 90, width: 0, height: 0)
        parent.present(popover, animated: true)
    }
    
    func updateTable(tasks: [TaskModel]) {
        MutableObservableArray(tasks).bind(to: completedTasksTableView) { (dataSoutce, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTaskCell") as! TasksTableViewCell
            cell.titleLabel.textColor = .systemGray
            cell.descrLabel.textColor = .systemGray
            
            cell.createdLabel.text = "Created: " + dataSoutce[indexPath.row].created.formattedDate()
            cell.deadlineLabel.text = "Deadline:" + dataSoutce[indexPath.row].deadline.formattedDate()
            
            cell.titleLabel.text = dataSoutce[indexPath.row].title
            cell.descrLabel.text = dataSoutce[indexPath.row].descr
            self.tasks = tasks
            return cell
        }
    }
}

extension CompletedViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
