//
//  HierarchyTitleCell.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyTitleCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(16))
        $0.textColor = .black_1
        return $0
    }(UILabel())
    
    var titleLabelBottomCons: NSLayoutConstraint?
    
    var model: HierarchyCellModel? {
        didSet {
            titleLabel.text = model?.title
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        selectedBackgroundView = UIView()
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        
        let left = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel.superview, attribute: .leading, multiplier: 1, constant: 10)
        let top = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel.superview, attribute: .top, multiplier: 1, constant: 10)
        let width = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: kSizeFrom750_Landscape(120))
        let bottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: titleLabel.superview, attribute: .bottom, multiplier: 1, constant: -10)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([left, top, width, bottom])
        titleLabelBottomCons = bottom
    }
}
