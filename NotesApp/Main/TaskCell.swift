import UIKit

class TaskCell: UITableViewCell {

    private let title = UILabel()
    private let checkBox = UIImageView()
    private let goToDetailButton = UIImageView()
    private let subtitle = UILabel()
    private let subtitlePictures = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCheckBox()
        configureTitle()
        configureGoToDetailButton()
        
    }
    
    func configure(task: Task) {
        if let taskDeadline = task.deadline {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM"
        
            self.subtitle.text = dateFormatter.string(from: taskDeadline)
            
            title.snp.makeConstraints { make in
                make.top.equalTo(self).inset(15)
                make.left.equalTo(checkBox.snp.right).offset(10)
                make.width.equalTo(230)
            }
            configureSubtitlePictures()
            configureSubtitle()
        } else {
            title.snp.makeConstraints { make in
                make.centerY.equalTo(self)
                make.left.equalTo(checkBox.snp.right).offset(10)
                make.width.equalTo(230)
            }
        }

        self.title.text = task.title
        
        if task.priority == .high {
            checkBox.image = UIImage(named: "importantCheckBox")
            self.title.text = "‼️ \(task.title)"
        }
        
        if task.isDone {
            checkBox.image = UIImage(named: "checkBoxIsDone")
            title.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            let attributeString = NSMutableAttributedString(string: title.text!)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            title.attributedText = attributeString
        }
    }

    private func configureCheckBox() {
        addSubview(checkBox)
        
        checkBox.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(self)
            make.left.equalTo(self).inset(16)
        }
        
        checkBox.image = UIImage(named: "defaultCheckBox")
    }
    
    private func configureTitle() {
        addSubview(title)
        title.font = UIFont.systemFont(ofSize: 17)
    }
    
    private func configureSubtitlePictures() {
        addSubview(subtitlePictures)
        
        subtitlePictures.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(1)
            make.left.equalTo(checkBox.snp.right).offset(10)
        }
        
        subtitlePictures.image = UIImage(systemName: "calendar")
        subtitlePictures.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
    }
    
    private func configureSubtitle() {
        addSubview(subtitle)
        
        subtitle.font = UIFont.systemFont(ofSize: 14)
        subtitle.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(2)
            make.left.equalTo(subtitlePictures.snp.right).offset(2)
        }
    }
    
    private func configureGoToDetailButton() {
        addSubview(goToDetailButton)
        
        goToDetailButton.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.width.equalTo(10)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(16)
        }
        
        goToDetailButton.image = UIImage(systemName: "chevron.right")
        goToDetailButton.tintColor = .gray
    }
    
    override func prepareForReuse() {
        title.text = nil
        title.textColor = .black
        checkBox.image = UIImage(named: "defaultCheckBox")
        subtitle.text = ""
        title.snp.removeConstraints()
        subtitlePictures.removeFromSuperview()
        
        let attributeString = NSMutableAttributedString(string: title.text ?? " ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: [], range: NSRange(location: 0, length: attributeString.length))
        title.attributedText = attributeString
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
