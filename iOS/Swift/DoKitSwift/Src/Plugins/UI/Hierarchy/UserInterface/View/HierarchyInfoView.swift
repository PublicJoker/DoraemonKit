//
//  HierarchyInfoView.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

enum HierarchyInfoViewAction: Int {
    case showParent
    case showSubview
    case showMoreInfo
}

protocol HierarchyInfoViewDelegate: NSObjectProtocol {
    func doraemonHierarchyInfoView(view: HierarchyInfoView, didSelectAt action: HierarchyInfoViewAction)
    func doraemonHierarchyInfoViewDidSelectCloseButton(view: HierarchyInfoView)
}

class HierarchyInfoView: MoveView {
    weak var delegate: HierarchyInfoViewDelegate?
    
    var selectedView: UIView?

    //MARK: - Getters and setters
    lazy var closeButton: UIButton = {
        $0.setImage(DKImage(named: "doraemon_close"), for: .normal)
        $0.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    private lazy var contentLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.textColor = .black_1
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        return $0
    }(UILabel())
    
    private lazy var frameLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.textColor = .black_1
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(frameLabelTapGestureRecognizer(sender:)))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
        return $0
    }(UILabel())
    
    private lazy var backgroundColorLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.textColor = .black_1
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundColorLabelTapGestureRecognizer(sender:)))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
        return $0
    }(UILabel())
    
    private lazy var textColorLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.textColor = .black_1
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(textColorLabelTapGestureRecognizer(sender:)))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
        return $0
    }(UILabel())
    
    private lazy var fontLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.textColor = .black_1
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(fontLabelTapGestureRecognizer(sender:)))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
        return $0
    }(UILabel())

    private lazy var tagLabel: UILabel = {
        $0.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.textColor = .black_1
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tagLabelTapGestureRecognizer(sender:)))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
        return $0
    }(UILabel())
    
    private lazy var actionContentView: UIView = {
        return $0
    }(UIView())

    private lazy var parentViewsButton: UIButton = {
        $0.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        $0.setTitle("Parent Views", for: .normal)
        $0.titleLabel?.textColor = .black_1
        $0.titleLabel?.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))

        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.black_1.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.tintColor = .black_1
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        $0.setImage(DKImage(named: "doraemon_hierarchy_parent")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tag = HierarchyInfoViewAction.showParent.rawValue
        $0.isEnabled = false
        return $0
    }(UIButton(type: .custom))
    
    private lazy var subviewsButton: UIButton = {
        $0.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        $0.setTitle("Subviews", for: .normal)
        $0.titleLabel?.textColor = .black_1
        $0.titleLabel?.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.black_1.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.tintColor = .black_1
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        $0.setImage(DKImage(named: "doraemon_hierarchy_subview")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tag = HierarchyInfoViewAction.showSubview.rawValue
        $0.isEnabled = false
        return $0
    }(UIButton(type: .custom))
    
    private lazy var moreButton: UIButton = {
        $0.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        $0.setTitle("More Info", for: .normal)
        $0.titleLabel?.textColor = .black_1
        $0.titleLabel?.font = .systemFont(ofSize: kSizeFrom750_Landscape(14))
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.black_1.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.tintColor = .black_1
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        $0.setImage(DKImage(named: "doraemon_hierarchy_info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tag = HierarchyInfoViewAction.showMoreInfo.rawValue
        $0.isEnabled = false
        return $0
    }(UIButton(type: .custom))
    
    private var actionContentViewHeight: CGFloat = 0.0
    
    override func initUI() {
        super.initUI()
        
        layer.borderColor = UIColor.black_1.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .white
        
        self.actionContentViewHeight = 80
        
        self.addSubview(closeButton)
        self.addSubview(contentLabel)
        self.addSubview(frameLabel)
        self.addSubview(backgroundColorLabel)
        self.addSubview(textColorLabel)
        self.addSubview(fontLabel)
        self.addSubview(tagLabel)
        self.addSubview(actionContentView)
        actionContentView.addSubview(parentViewsButton)
        actionContentView.addSubview(subviewsButton)
        actionContentView.addSubview(moreButton)
        
        updateHeightIfNeeded()
    }
    
    func updateSelectedView(view: UIView?) {
        guard let mView = view else {
            return
        }
        
        if selectedView == mView {
            return
        }
        
        moreButton.isEnabled = true
        parentViewsButton.isEnabled = mView.superview != nil
        subviewsButton.isEnabled = mView.subviews.count > 0
        
        selectedView = mView
        
        let boldAttri = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let attri = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let name = NSMutableAttributedString(string: "Name: ", attributes: boldAttri)
        name.append(NSAttributedString(string: NSStringFromClass(type(of: mView)), attributes: attri))
        
        contentLabel.attributedText = name
        frameLabel.text = "Frame: "
        backgroundColorLabel.text = "Background: "
        
        contentLabel.sizeToFit()
        frameLabel.sizeToFit()
        backgroundColorLabel.sizeToFit()
        textColorLabel.sizeToFit()
        fontLabel.sizeToFit()
        tagLabel.sizeToFit()
        
        updateHeightIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        closeButton.frame = CGRect(x: width - 10 - 30, y: 10, width: 30, height: 30)
        
        actionContentView.frame = CGRect(x: 0, y: height - actionContentViewHeight - 10, width: width, height: actionContentViewHeight)
        
        contentLabel.frame = CGRect(x: 10, y: 10, width: closeButton.originX - 10 - 10, height: contentLabel.height)
    }
    
    private func updateHeightIfNeeded() {
        let contentHeight: CGFloat = contentLabel.height + frameLabel.height + backgroundColorLabel.height + textColorLabel.height + fontLabel.height + tagLabel.height
        let newHeight: CGFloat = 10 + max(contentHeight, 10 + 30/*self.closeButton.doraemon_height*/) + 10 + actionContentViewHeight + 10
        
        if newHeight != height {
            height = newHeight
            if !isMoved {
                self.bottom = kScreenHeight - 10 * 2
            }
        }
    }
}

// MARK: -- Event responses
extension HierarchyInfoView {
    @objc func buttonClicked(_ sender: UIButton) {
        self.delegate?.doraemonHierarchyInfoView(view: self, didSelectAt: HierarchyInfoViewAction(rawValue: sender.tag) ?? HierarchyInfoViewAction.showParent)
    }
    
    @objc func closeButtonClicked() {
        self.delegate?.doraemonHierarchyInfoViewDidSelectCloseButton(view: self)
    }
    
    @objc func frameLabelTapGestureRecognizer(sender: UITapGestureRecognizer) {
//        self.selectedView.doraemon_showFrameAlertAndAutomicSetWithKeyPath("frame")
    }
    
    @objc func backgroundColorLabelTapGestureRecognizer(sender: UITapGestureRecognizer) {
        //        self.selectedView.doraemon_showFrameAlertAndAutomicSetWithKeyPath("backgroundColor")
    }
    
    @objc func textColorLabelTapGestureRecognizer(sender: UITapGestureRecognizer) {
        //        self.selectedView.doraemon_showFrameAlertAndAutomicSetWithKeyPath("textColor")
    }
    
    @objc func fontLabelTapGestureRecognizer(sender: UITapGestureRecognizer) {
        //        self.selectedView.doraemon_showFrameAlertAndAutomicSetWithKeyPath("font")
    }
    
    @objc func tagLabelTapGestureRecognizer(sender: UITapGestureRecognizer) {
        //        self.selectedView.doraemon_showFrameAlertAndAutomicSetWithKeyPath("tag")
    }
}
