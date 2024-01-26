import Foundation
import UIKit
import SnapKit

class TaskDetailController: UIViewController {
    
    let header = Header()
    let underHeader = UIView()
    let textViewView = TextView()
    private let additionalInfo = AdditionalInfoView()
    private let delete = DeleteView()
    var dismissAction: (()->())? = nil
    let taskDetailScroll = UIScrollView()
    
    private var task: Task? = nil
    private let taskService = TaskService.shared
    
    init(task: Task?) {
        super.init(nibName: nil, bundle: nil)
        
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        
        configureTaskDetailScroll()
        configureUnderHeader()
        configureHeader()
        configureTextViewView()
        configureAdditionalInfo()
        configureDelete()
        registerForKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        updateConstraints()
    }
    
    func updateConstraints() {
        self.textViewView.snp.removeConstraints()
        self.textViewView.snp.makeConstraints { make in
            make.top.equalTo(taskDetailScroll).offset(86)
            make.left.right.equalTo(taskDetailScroll).inset(16)
            make.height.greaterThanOrEqualTo(130)
            make.height.greaterThanOrEqualTo(self.textViewView.descriptionTask.snp.height)
            make.width.equalTo(taskDetailScroll.snp.width).inset(16)
        }
    }
    
    private func configureTaskDetailScroll() {
        view.addSubview(taskDetailScroll)
        
        taskDetailScroll.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view)
        }
        
        taskDetailScroll.showsVerticalScrollIndicator = false
    }
    
    private func configureUnderHeader() {
        view.addSubview(underHeader)
        
        underHeader.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        
        underHeader.snp.makeConstraints { make in
            make.left.right.top.equalTo(view)
            make.height.equalTo(70)
        }
    }
 
    private func configureHeader() {
        underHeader.addSubview(header)
        
        header.snp.makeConstraints { make in
            make.left.right.top.equalTo(underHeader)
            make.height.equalTo(70)
        }
        
        header.cancellButtonTap = {
            self.dismiss(animated: true)
        }
        
        header.saveButtonTap = {
            var task = Task(
                id: self.task?.id ?? UUID(),
                title: self.textViewView.descriptionTask.text,
                isDone: self.task?.isDone ?? false,
                priority: self.additionalInfo.getPriority(),
                deadline: self.additionalInfo.selectedDate
            )
            self.taskService.appendOrUpdate(task: task)
            self.dismiss(animated: true)
            self.dismissAction?()
        }
    }
    
    private func configureTextViewView() {
        taskDetailScroll.addSubview(textViewView)
    
        textViewView.backgroundColor = .white
        textViewView.layer.cornerRadius = 16
        
        textViewView.snp.makeConstraints { make in
            make.top.equalTo(taskDetailScroll).offset(86)
            make.left.right.equalTo(taskDetailScroll).inset(16)
            make.height.equalTo(130)
            make.width.equalTo(taskDetailScroll.snp.width).inset(16)
        }
        
        textViewView.startEdit = {
            self.unlockedButtons()
        }
        
        textViewView.endEdidWithEmptyText = {
            self.lockedButtons()
        }
        
        if let task = task {
            textViewView.descriptionTask.text = task.title
            textViewView.descriptionTask.textColor = UIColor.black
            unlockedButtons()
        } else {
            textViewView.descriptionTask.text = "Что надо сделать?"
            textViewView.descriptionTask.textColor = UIColor.lightGray
            lockedButtons()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textViewView.descriptionTask.resignFirstResponder()
    }
    
    private func lockedButtons() {
        self.header.saveButtonLocked()
        self.delete.deleteButtonLocked()
    }
    
    private func unlockedButtons() {
        self.header.saveButtonUnLocked()
        self.delete.deleteButtonUnLocked()
        
    }
    
    private func configureAdditionalInfo() {
        taskDetailScroll.addSubview(additionalInfo)
        let firstHeight = task?.deadline != nil ? 405 : 114
        
        additionalInfo.backgroundColor = .white
        additionalInfo.layer.cornerRadius = 16
        additionalInfo.snp.makeConstraints { make in
            make.top.equalTo(textViewView.snp.bottom).offset(18)
            make.left.right.equalTo(taskDetailScroll).inset(16)
            make.height.equalTo(firstHeight)
        }

        switch task?.priority {
        case .low: additionalInfo.importantSegment.selectedSegmentIndex = 0
        case .normal: additionalInfo.importantSegment.selectedSegmentIndex = 1
        case .high: additionalInfo.importantSegment.selectedSegmentIndex = 2
        default: additionalInfo.importantSegment.selectedSegmentIndex = 1
        }
        
        if let deadline = task?.deadline {
            additionalInfo.diedlineSwitch.setOn(true, animated: true)
            additionalInfo.calendar.alpha = 1
            additionalInfo.calendar.date = deadline
        }
        
        additionalInfo.switchIsOn = { isOn in
            self.additionalInfo.snp.removeConstraints()
            
            let height: CGFloat = isOn ? 405 : 114
            
            self.additionalInfo.snp.makeConstraints { make in
                make.top.equalTo(self.textViewView.snp.bottom).offset(18)
                make.left.right.equalTo(self.taskDetailScroll).inset(16)
                make.height.equalTo(height)
            }
            
            let calendarAlfa: Float = isOn ? 1 : 0
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutSubviews()
                self.additionalInfo.calendar.layer.opacity = calendarAlfa
            }
        }
        
        textViewView.textEditing = {
            self.updateConstraints()
        }
    }

    private func configureDelete() {
        taskDetailScroll.addSubview(delete)
        
        delete.backgroundColor = .white
        delete.layer.cornerRadius = 16
        
        delete.snp.makeConstraints { make in
            make.top.equalTo(additionalInfo.snp.bottom).offset(18)
            make.left.right.equalTo(taskDetailScroll).inset(16)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualTo(taskDetailScroll)
        }
        
        delete.deleteButtonTap = {
            var task = Task(
                id: self.task?.id ?? UUID(),
                title: self.textViewView.descriptionTask.text,
                isDone: false,
                priority: self.additionalInfo.getPriority()
            )
            self.taskService.deleteTask(task: task)
            self.dismiss(animated: true)
            self.dismissAction?()
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func kbWillShow(notification: Notification) { 
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var contentInset: UIEdgeInsets = UIEdgeInsets()
        contentInset.bottom = kbFrameSize.size.height + 20
        taskDetailScroll.contentInset = contentInset
    }
    
    @objc private func kbWillHide(notification: Notification) {
        var contentInset: UIEdgeInsets = UIEdgeInsets()
        contentInset.bottom = 0
        taskDetailScroll.contentInset = contentInset
    }
}

