import Foundation
import UIKit
import SnapKit

class AdditionalInfoView: UIView {
    
    private let importantLabel = UILabel()
    private let diedlineLabel = UILabel()
    var importantSegment: UISegmentedControl! = nil
    let diedlineSwitch = UISwitch()
    private let lineForBackground = UIView()
    let calendar = UIDatePicker()
    private let lineForBackground2 = UIView()
    var selectedDate: Date?
    var switchIsOn: ((Bool)->())? = nil
    
    
    init() {
        super.init(frame: .zero)
        self.clipsToBounds = true
        
        configureImportantLabel()
        configureDiedlineLabel()
        configureImportantSegment(title: [UIImage(systemName: "arrow.down.app"), "нет", "‼️"])
        configureDiedlineSwitch()
        configureLineForBackground()
        configureCalendar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureImportantLabel() {
        addSubview(importantLabel)
        
        importantLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(18)
            make.left.right.equalTo(self).inset(16)
        }
        
        importantLabel.text = "Важность"
    }
    
    private func configureDiedlineLabel() {
        addSubview(diedlineLabel)
        
        diedlineLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self).inset(18)
            make.top.equalTo(importantLabel.snp.bottom).offset(36)
        }
        
        diedlineLabel.text = "Сделать до"
    }
    
    private func configureImportantSegment(title: [Any]) {
        let importantSegment = UISegmentedControl(items: title)
        addSubview(importantSegment)
        
        importantSegment.snp.makeConstraints { make in
            make.right.equalTo(self).inset(16)
            make.left.equalTo(self).offset(220)
            make.top.equalTo(self).inset(12)
        }
        
        self.importantSegment = importantSegment
    }
    
    func getPriority() -> Task.Priority {
        switch importantSegment.selectedSegmentIndex {
        case 0: return .low
        case 1: return .normal
        case 2: return .high
        default: return .normal
        }
    }
    
    private func configureDiedlineSwitch() {
        addSubview(diedlineSwitch)
        
        diedlineSwitch.snp.makeConstraints { make in
            make.right.equalTo(self).inset(16)
            make.top.equalTo(self).inset(68)
        }
        
        diedlineSwitch.addTarget(self, action: #selector(diedlineSwitchAction), for: .valueChanged)
    }

    private func configureLineForBackground() {
        addSubview(lineForBackground)
        
        lineForBackground.backgroundColor = .lightGray
        lineForBackground.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(57)
            make.height.equalTo(0.5)
            make.left.right.equalTo(self).inset(16)
        }
    }
    
    private func configureCalendar() {
        addSubview(calendar)
        calendar.layer.opacity = 0
        calendar.preferredDatePickerStyle = .inline
    
        calendar.snp.makeConstraints { make in
            make.top.equalTo(diedlineSwitch.snp.bottom)
            make.left.right.equalTo(self).inset(10)
        }
        calendar.addTarget(self, action: #selector(setDate), for: .valueChanged)
    }

    private func configureLineForBackground2() {
        calendar.addSubview(lineForBackground2)

        lineForBackground2.backgroundColor = .lightGray
        lineForBackground2.snp.makeConstraints { make in
            make.top.equalTo(calendar)
            make.height.equalTo(0.5)
            make.left.right.equalTo(self).inset(16)
        }
    }

    @objc func diedlineSwitchAction() {
        if diedlineSwitch.isOn {
            selectedDate = calendar.date
            switchIsOn?(true)
        } else {
            selectedDate = nil
            switchIsOn?(false)
        }
    }
    
    @objc func setDate() {
        selectedDate = calendar.date
    }
}

