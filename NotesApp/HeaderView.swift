import Foundation
import UIKit
import SnapKit

class Header: UIView {
    
    private let titleTaskDetailController = UILabel()
    private let cancellButton = UIButton()
    let saveButton = UIButton()
    
    var cancellButtonTap: (() -> ())? = nil
    var saveButtonTap: (() -> ())? = nil
    
    init() {
        super.init(frame: .zero)
    
        configureTitleTaskDetailController()
        configureSaveButton()
        configureCancellButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func saveButtonUnLocked() {
        saveButton.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
        saveButton.isUserInteractionEnabled = true
    }
    
    func saveButtonLocked() {
        saveButton.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3), for: .normal)
        saveButton.isUserInteractionEnabled = false
    }
    
    private func configureTitleTaskDetailController() {
        addSubview(titleTaskDetailController)
        
        titleTaskDetailController.text = "Дело"
        
        titleTaskDetailController.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(25)
        }
    }
    
    private func configureCancellButton() {
        addSubview(cancellButton)
        
        cancellButton.setTitle("Отменить", for: .normal)
        cancellButton.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
        
        cancellButton.snp.makeConstraints { make in
            make.left.equalTo(self).inset(16)
            make.top.equalTo(self).inset(18)
        }        
        cancellButton.addTarget(self, action:#selector(cancellButtonAction) , for: .touchUpInside)
    }
    
    private func configureSaveButton() {
        addSubview(saveButton)
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.gray, for: .normal)
        
        saveButton.snp.makeConstraints { make in
            make.right.equalTo(self).inset(16)
            make.top.equalTo(self).inset(18)
        }
        
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }
    
    @objc func saveButtonAction() {
        saveButtonTap?()
    }
    
    @objc func cancellButtonAction() {
        cancellButtonTap?()
    }
}
