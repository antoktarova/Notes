import Foundation
import UIKit
import SnapKit

class HeaderView: UIView {
    
    var cancelButonTapped: (() -> ())? = nil
    
    let titleTaskDetailController = UILabel()
    let cancellButton = UIButton()
    let saveButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        configureTitleTaskDetailController()
        configureSaveButton()
        configureCancellButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitleTaskDetailController() {
        addSubview(titleTaskDetailController)
        
        titleTaskDetailController.text = "Дело"
        
        titleTaskDetailController.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).inset(25)
        }
    }
    
    func configureCancellButton() {
        addSubview(cancellButton)
        
        cancellButton.setTitle("Отменить", for: .normal)
        cancellButton.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
        
        cancellButton.snp.makeConstraints { make in
            make.left.equalTo(self).inset(16)
            make.top.equalTo(self).inset(18)
        }

        cancellButton.addTarget(self, action:#selector(cancelButtonAction) , for: .touchUpInside)
    }
    
    func configureSaveButton() {
        addSubview(saveButton)
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.gray, for: .normal)
        
        saveButton.snp.makeConstraints { make in
            make.right.equalTo(self).inset(16)
            make.top.equalTo(self).inset(18)
        }
    }
    
    @objc func cancelButtonAction() {
        cancelButonTapped?()
    }
}
