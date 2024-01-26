import Foundation
import UIKit
import SnapKit

class TextView: UIView {
    
    let descriptionTask = UITextView()
    var startEdit: (()->())? = nil
    var endEdidWithEmptyText: (()->())? = nil
    var textEditing: (()->())? = nil
    
    init() {
        super.init(frame: .zero)
    
        configureDescriptionTask()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDescriptionTask() {
        addSubview(descriptionTask)
        
        descriptionTask.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
        }
        
        descriptionTask.delegate = self
        descriptionTask.font = UIFont.systemFont(ofSize: 17)
        descriptionTask.backgroundColor = .white
        descriptionTask.layer.cornerRadius = 16
        descriptionTask.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        descriptionTask.isScrollEnabled = false
    }
}

extension TextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTask.textColor == UIColor.lightGray {
            descriptionTask.text = nil
            descriptionTask.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTask.text.isEmpty {
            descriptionTask.text = "Что надо сделать?"
            descriptionTask.textColor = UIColor.lightGray
            endEdidWithEmptyText?()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        textEditing?()

        var reasonForUnlocked = 0
        for char in descriptionTask.text {
            if char != " " {
                reasonForUnlocked += 1
            }
        }
        
        if reasonForUnlocked != 0 {
            startEdit?()
        } else {
            endEdidWithEmptyText?()
        }
    }
}
