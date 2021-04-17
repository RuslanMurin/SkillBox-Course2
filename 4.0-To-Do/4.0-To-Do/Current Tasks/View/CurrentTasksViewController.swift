import UIKit

class CurrentTasksViewController: UIViewController, ViewModelOutput{
    @IBOutlet weak var currentTasksTableView: UITableView!
    
    private var viewModel: ViewModelInput! = CurrentTasksViewModel.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.output = self
        updateTable()
        rowSelected()
    }
    
    func updateTable() {
        viewModel = CurrentTasksViewModel()
        viewModel.tasks.bind(to: currentTasksTableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTaskCell") as! TasksTableViewCell
            
            cell.titleLabel.textColor = .systemBlue
            cell.descrLabel.textColor = .systemBlue
            
            cell.titleLabel.text = dataSource[indexPath.row].title
            cell.descrLabel.text = dataSource[indexPath.row].descr
            cell.deadlineLabel.text = "Deadline: " +  dataSource[indexPath.row].deadline.formattedDate()
            cell.createdLabel.text = "Created: " + dataSource[indexPath.row].created.formattedDate()
            return cell
        }
    }
    
    func rowSelected() {
        currentTasksTableView.reactive.selectedRowIndexPath.observeNext { indexPath in
            let cell = self.currentTasksTableView.cellForRow(at: indexPath)
            guard let popover = (self.storyboard?.instantiateViewController(withIdentifier: "ActionPopover") as? ActionPopoverViewController) else { return }
            popover.modalPresentationStyle = .popover
            popover.delegate = self
            popover.preferredContentSize = CGSize(width: 100, height: 150)
            weak var popoverVC = popover.popoverPresentationController
            popoverVC?.delegate = self
            popoverVC?.sourceView = cell
            popoverVC?.sourceRect = CGRect(x: cell?.bounds.midX ?? 50, y: 90, width: 0, height: 0)
            popover.task = self.viewModel.tasks[indexPath.row]
            self.present(popover, animated: true)
        }
        .dispose(in: reactive.bag)
    }
}

extension CurrentTasksViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
