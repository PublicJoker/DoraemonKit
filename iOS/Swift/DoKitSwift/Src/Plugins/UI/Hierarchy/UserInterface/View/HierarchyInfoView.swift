//
//  HierarchyInfoView.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

enum HierarchyInfoViewAction: Int {
    case HierarchyInfoViewActionShowParent
    case HierarchyInfoViewActionShowSubview
    case HierarchyInfoViewActionShowMoreInfo
}

protocol HierarchyInfoViewDelegate: NSObjectProtocol {
    func doraemonHierarchyInfoView(view: HierarchyInfoView, didSelectAt action: HierarchyInfoViewAction)
    func doraemonHierarchyInfoViewDidSelectCloseButton(view: HierarchyInfoView)
}

class HierarchyInfoView: MoveView {
    weak var delegate: HierarchyInfoViewDelegate?
    
    var selectedView: UIView?
    var closeButton: UIButton?
    
    override func initUI() {
        super.initUI()
        
        self.layer.borderColor = UIColor.black_1().cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        backgroundColor = .white
    }
    
    private func updateSelectedView(view: UIView) {
        
    }
}
