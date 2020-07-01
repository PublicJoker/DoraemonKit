//
//  HierarchyHeaderView.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyHeaderView: UIView {
    lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(18))
        $0.textColor = .black
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10, y: 0, width: width - 10 * 2, height: height)
    }
}
