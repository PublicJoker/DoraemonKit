//
//  HierarchyCellModel.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyCellModel: NSObject {
    var _title: String?
    var title: String? { _title }
    
    var _cellClass: String?
    var cellClass: String? { _cellClass }
    
    // Style1
    var flag = false
    
    // Style2 / Style3
    var detailTitle: String?
    
    // Style4
    var value: Float?
    
    
    // Block
    var block: (() -> Void)? {
        didSet {
            _cellClass = NSStringFromClass((block != nil) ? HierarchySelectorCell.self : HierarchyDetailTitleCell.self)
        }
    }
    var changePropertyBlock: ((Any) -> Void)?
    
    // Separator
    
    var separatorInsets: UIEdgeInsets?
    
    init(title: String? = nil, flag pFlag: Bool) {
        _title = title
        flag = pFlag
        separatorInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        _cellClass = NSStringFromClass(HierarchySwitchCell.self)
    }
    
    init(title: String? = nil, detailTitle pDetailTitle: String? = nil, flag pFlag: Bool) {
        _title = title
        flag = pFlag
        detailTitle = pDetailTitle
        separatorInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        _cellClass = NSStringFromClass(HierarchySwitchCell.self)
    }
    
    init(title: String? = nil, detailTitle pDetailTitle: String? = nil) {
        _title = title
        detailTitle = pDetailTitle
        separatorInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        _cellClass = NSStringFromClass(HierarchyDetailTitleCell.self)
    }
    
    func normalInsets() -> HierarchyCellModel {
        separatorInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return self
    }
    
    func noneInsets() -> HierarchyCellModel {
        separatorInsets = UIEdgeInsets(top: 0, left: kScreenWidth, bottom: 0, right: 0)
        return self
    }
}
