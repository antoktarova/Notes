import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    let addButton = UIButton()
    let titleLabel = UILabel()
    let numberTasksIsDoneTitle = UILabel()
    let showButton = UIButton()
    private let taskService = TaskService.shared
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        
        tasks = taskService.getTasks()
        configureTitleLabel()
        configureTableView()
        configureAddButton()
        configurenumberTasksIsDoneTitle()
        configurateShowButton()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        let heighTable = (tasks.count + 1) * 65
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.left.right.equalTo(view).inset(16)
            make.height.equalTo(heighTable).priority(.low)
            make.bottom.lessThanOrEqualTo(view).inset(105).priority(.high)
        }
        
        tableView.layer.cornerRadius = 16
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.register(AdditionalCell.self, forCellReuseIdentifier: "AddCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    func tableViewReload() {
        tableView.reloadData()
    }
    
    func configureAddButton() {
        view.addSubview(addButton)
        addButton.backgroundColor = UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .white
        addButton.layer.cornerRadius = 22
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOpacity = 0.3
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).inset(50)
            make.height.width.equalTo(44)
        }
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
    }
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.text = "Мои дела"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(view).inset(25)
            make.height.equalTo(30)
            make.top.equalTo(view).inset(95)
        }
    }
    
    func configurenumberTasksIsDoneTitle() {
        view.addSubview(numberTasksIsDoneTitle)
        
        numberTasksIsDoneTitle.text = "Выполнено - \(taskService.getNumberTasksIsDone())"
        numberTasksIsDoneTitle.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        
        numberTasksIsDoneTitle.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.top).inset(-16)
            make.left.right.equalTo(view).inset(25)
        }
    }
    
    func configurateShowButton() {
        view.addSubview(showButton)
        showButton.setTitle("Скрыть", for: .normal)
        showButton.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
        showButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        
        showButton.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.top).inset(-10)
            make.right.equalTo(view).inset(25)
        }
        
        showButton.addTarget(self, action: #selector(showButtonAction), for: .touchUpInside)
    }
    
    func updateTable() {
        self.numberTasksIsDoneTitle.text = "Выполнено - \(self.taskService.getNumberTasksIsDone())"
        self.tasks = self.taskService.getTasks()
        self.tableView.reloadData()
        
        self.tableView.snp.removeConstraints()
        let heighTable = (tasks.count + 1) * 65
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.left.right.equalTo(view).inset(16)
            make.height.equalTo(heighTable)
            make.bottom.lessThanOrEqualTo(view)
        }
        view.layoutSubviews()
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func addButtonAction() {
        var vc = TaskDetailController(task: nil)
        vc.dismissAction = {
            self.updateTable()
        }
        present(vc, animated: true)
    }
    
    @objc func showButtonAction() {
        if showButton.titleLabel?.text == "Скрыть" {
            showButton.setTitle("Показать", for: .normal)
            tasks = taskService.getPendingTasks()
        } else {
            showButton.setTitle("Скрыть", for: .normal)
            tasks = taskService.getTasks()
        }        
        tableViewReload()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == tasks.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as? AdditionalCell else { return UITableViewCell() }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else { return UITableViewCell() }
            
            cell.configure(task: tasks[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc: TaskDetailController
        
        if indexPath.row == tasks.count {
            vc = TaskDetailController(task: nil)
        } else {
            vc = TaskDetailController(task: tasks[indexPath.row])
        }
        
        vc.dismissAction = {
            self.updateTable()
        }

        present(vc, animated: true) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.setSelected(false, animated: true)
        }
    }
    
    func taskMarkAsDoneSwipe(indexCell: IndexPath) {
        tasks[indexCell.row].isDone = true
        let cell = tableView.cellForRow(at: indexCell) as? TaskCell
        cell?.configure(task: tasks[indexCell.row])
        taskService.saveTasks(tasks: tasks)
        self.numberTasksIsDoneTitle.text = "Выполнено - \(self.taskService.getNumberTasksIsDone())"
    }
    
    func taskDeleteSwipe(indexCell: IndexPath) {
        tasks.remove(at: indexCell.row)
        taskService.saveTasks(tasks: tasks)
        
        self.updateTable()
    }
    
    func infoSwipe(indexCell: IndexPath) {
        var vc = TaskDetailController(task: tasks[indexCell.row])
        
        vc.dismissAction = {
            self.updateTable()
        }
        
        present(vc, animated: true) { [self] in
            let cell = self.tableView.cellForRow(at: indexCell)
            cell?.setSelected(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.row < tasks.count else { return nil }
        
        let action = UIContextualAction(
            style: .normal,
            title: "isDone"
        ) { (action, view, completionHandler) in
            self.taskMarkAsDoneSwipe(indexCell: indexPath)
            completionHandler(true)
        }
        action.backgroundColor = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)
        action.image = UIImage(named: "swipeForDone")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.row < tasks.count else { return nil }

        let action1 = UIContextualAction(
            style: .normal,
            title: "Trash"
        ) { (action, view, completionHandler) in
            self.taskDeleteSwipe(indexCell: indexPath)
            completionHandler(true)
        }
        action1.backgroundColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1)
        action1.image = UIImage(named: "swipeForDelete")
        
        let action2 = UIContextualAction(
            style: .normal,
            title: "Info"
        ) { (action, view, completionHandler) in
            self.infoSwipe(indexCell: indexPath)
            completionHandler(true)
        }
        action2.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1)
        action2.image = UIImage(named: "infoSwipe")
        
        return UISwipeActionsConfiguration(actions: [action1, action2])
    }
}

