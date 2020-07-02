//
//  HierarchyDetailTitleCell.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyDetailTitleCell: HierarchyTitleCell {
    lazy var detailLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.textColor = .black_1
        $0.textAlignment = .right
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    var detailLabelRightCons: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initUI() {
        super.initUI()
        
        contentView.addSubview(detailLabel)
        contentView.removeConstraint(titleLabelBottomCons!)
        
        let right = NSLayoutConstraint(item: detailLabel, attribute: .trailing, relatedBy: .equal, toItem: detailLabel.superview, attribute: .trailing, multiplier: 1, constant: -10)
        let top = NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: detailLabel.superview, attribute: .top, multiplier: 1, constant: 10)
        let bottom = NSLayoutConstraint(item: detailLabel, attribute: .bottom, relatedBy: .equal, toItem: detailLabel.superview, attribute: .bottom, multiplier: 1, constant: -10)
        let left = NSLayoutConstraint(item: detailLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 10 / 2.0)

        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([right, top, bottom, left])
        detailLabelRightCons = bottom
    }
} 
