import Foundation
import UIKit
import SnapKit

class DeleteView: UIView {
    
    let deleteButton = UIButton()
    var deleteButtonTap: (()->())? = nil
    
    init() {
        super.init(frame: .zero)
    
        configureDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deleteButtonUnLocked() {
        deleteButton.setTitleColor(UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1), for: .normal)
        deleteButton.isUserInteractionEnabled = true
    }
    
    func deleteButtonLocked() {
        deleteButton.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), for: .normal)
        deleteButton.isUserInteractionEnabled = false 
    }
    
    
    func configureDeleteButton() {
        addSubview(deleteButton)
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.gray, for: .normal)
        
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(50)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
    }
    
    @objc func deleteButtonAction() {
        deleteButtonTap?()
    }
}
