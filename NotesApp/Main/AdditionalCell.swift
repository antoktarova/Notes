import UIKit

class AdditionalCell: UITableViewCell {

    private let title = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureTitle()
    }

    private func configureTitle() {
        addSubview(title)
        
        title.text = "Новое"
        title.font = UIFont.systemFont(ofSize: 17)
        title.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        title.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp.left).inset(34)
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

