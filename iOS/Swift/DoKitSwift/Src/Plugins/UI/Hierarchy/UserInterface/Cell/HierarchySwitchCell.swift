//
//  HierarchySwitchCell.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchySwitchCell: HierarchyDetailTitleCell {
    lazy var swit: UISwitch = {
        $0.addTarget(self, action: #selector(switchValueChanged(sender:)), for: .valueChanged)
        return $0
    }(UISwitch())
    
    override var model: HierarchyCellModel? {
        set {
            super.model = newValue
            swit.isOn = newValue?.flag ?? false
        }
        get {
            return super.model
        }
    }
    
    override func initUI() {
        super.initUI()
        
        contentView.addSubview(swit)
        contentView.removeConstraint(detailLabelRightCons!)
        
        let left = NSLayoutConstraint(item: swit, attribute: .leading, relatedBy: .equal, toItem: detailLabel, attribute: .trailing, multiplier: 1, constant: 10 / 2.0)
        let right = NSLayoutConstraint(item: swit, attribute: .trailing, relatedBy: .equal, toItem: swit.superview, attribute: .trailing, multiplier: 1, constant: -10)
        let centerY = NSLayoutConstraint(item: swit, attribute: .centerY, relatedBy: .equal, toItem: swit.superview, attribute: .centerY, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: swit, attribute: .bottom, relatedBy: .equal, toItem: swit.superview, attribute: .bottom, multiplier: 1, constant: 51)
        let height = NSLayoutConstraint(item: swit, attribute: .leading, relatedBy: .equal, toItem: swit, attribute: .trailing, multiplier: 1, constant: 31)

        swit.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([left, right, centerY, width, height])
    }
    
    @objc func switchValueChanged(sender: UISwitch) {
        model?.flag = sender.isOn
        model?.changePropertyBlock?(NSNumber(booleanLiteral: sender.isOn))
    }
}
