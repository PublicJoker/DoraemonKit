//
//  HierarchyViewController.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

import UIKit

func synchronized(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

class HierarchyViewController: BaseViewController {
    var delegate: HierarchyInfoViewDelegate?
    
    lazy var borderView: UIView = {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 2
        return $0
    }(UIView())
    
    var observeViews: Set<UIView>? = []
    
    var borderViews: Dictionary<NSNumber, UIView>? = [:]
        
    lazy var pickerView: HierarchyPickerView = {
        let height: CGFloat = 100
        $0.frame = CGRect(x: (kScreenWidth - 60) / 2.0, y: (kScreenHeight - 60) / 2.0, width: 60, height: 60)
        $0.initUI()
        return $0
    }(HierarchyPickerView())
    
    lazy var infoView: HierarchyInfoView = {
        let height: CGFloat = 100
        $0.frame = CGRect(x: 10, y: kScreenHeight - 10 * 2 - height, width: kScreenWidth - 10 * 2, height: height)
        $0.initUI()
        return $0
    }(HierarchyInfoView())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.1)
        
        
        infoView.delegate = self
        view.addSubview(infoView)
        view.addSubview(borderView)
        view.addSubview(pickerView)
    }
    
    deinit {
        for view in observeViews ?? [] {
            stopObserveView(view)
        }
        observeViews?.removeAll()
    }
    
    func beginObserveView(view: UIView, borderWidth: CGFloat) {
        guard self.observeViews?.contains(view) == false else {
            return
        }
        
        let borderView = UIView()
        borderView.backgroundColor = .clear
        view.addSubview(borderView)
        view.sendSubviewToBack(borderView)
        // TODO: doraemon_hashColor
        borderView.layer.borderColor = view.hashColor().cgColor
        borderView.layer.borderWidth = borderWidth
        borderView.frame = frameInLocalForView(view)
        
        borderViews![NSNumber(value: borderView.hash)] = borderView
        
        view.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
    
    func stopObserveView(_ view: UIView) {
        guard self.observeViews?.contains(view) == true else {
            return
        }
        
        let borderView = self.borderViews?[NSNumber(value: view.hash)]
        borderView?.removeFromSuperview()
        view.removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let view = object as? UIView else { return }
        updateOverlayIfNeeded(view)
    }
    
    func updateOverlayIfNeeded(_ view: UIView) {
        guard let borderView = self.borderViews?[NSNumber(value: view.hash)] else { return }
        borderView.frame = frameInLocalForView(borderView)
    }
    
    func frameInLocalForView(_ view: UIView) -> CGRect {
        let keyWindow = getKeyWindow()
        var rect = view.convert(view.bounds, to: keyWindow)
        rect = self.view.convert(rect, to: keyWindow)
        return rect
    }
    
    func findSelectedViewInViews(selectedViews: [UIView]) -> UIView? {
        if (HierarchyHelper.shared.isHierarchyIgnorePrivateClass) {
            var views: [UIView] = []
            for view in selectedViews {
                if !NSStringFromClass(type(of: view)).hasPrefix("_") {
                    views.append(view)
                }
            }
            return views.last
        } else {
            return selectedViews.last
        }
    }
    
    func findParentViewsBySelectedView(selectedView: UIView) -> [UIView] {
        var superViews: [UIView] = []
        var superView = selectedView.superview
        
        while let superV = superView {
            if (HierarchyHelper.shared.isHierarchyIgnorePrivateClass) {
                if !NSStringFromClass(type(of: view)).hasPrefix("_") {
                    superViews.append(superV)
                }
            } else {
                superViews.append(superV)
            }
            superView = superV.superview
        }
        return superViews
    }
    
    func findSubviewsBySelectedView(selectedView: UIView) -> [UIView] {
        var subviews: [UIView] = []
        
        for subView in selectedView.subviews {
            if (HierarchyHelper.shared.isHierarchyIgnorePrivateClass) {
                if !NSStringFromClass(type(of: view)).hasPrefix("_") {
                    subviews.append(subView)
                }
            } else {
                subviews.append(subView)
            }
        }
        return subviews
    }
}

extension HierarchyViewController: HierarchyViewDelegate {
    func doraemonHierarchyView(view: HierarchyPickerView, didMoveTo selectedViews: [UIView]) {
        synchronized(lock: self) {
            for observeView in observeViews ?? [] {
                stopObserveView(observeView)
            }
            
            observeViews?.removeAll()
            
            for (index, selectedView)  in selectedViews.reversed().enumerated() {
                var borderWidth: CGFloat = 1
                if index == selectedViews.count - 1 {
                    borderWidth = 2
                }
                beginObserveView(view: selectedView, borderWidth: borderWidth)
                observeViews!.insert(selectedView)
            }
        }
    }
}

extension HierarchyViewController: HierarchyInfoViewDelegate {
    func doraemonHierarchyInfoView(view: HierarchyInfoView, didSelectAt action: HierarchyInfoViewAction) {
        guard let selectView = self.infoView.selectedView else {
            return
        }

        switch (action) {
        case .showMoreInfo:
            showHierarchyInfo(selectView)
        case .showParent:
            showParentSheet(selectView)
        case .showSubview:
            showSubviewSheet(selectView)
        }
    }
    
    func doraemonHierarchyInfoViewDidSelectCloseButton(view: HierarchyInfoView) {
        HierarchyHelper.shared.window?.hide()
        HierarchyHelper.shared.window = nil
    }
    
    func showHierarchyInfo(_ selectView: UIView) {
        let detailVC = HierarchyDetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.selectView = selectView
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func showParentSheet(_ selectView: UIView) {
        let actions = NSMutableArray()
        
        let parentViews = findParentViewsBySelectedView(selectedView: selectView)
        
        for view in parentViews {
            actions.add(NSStringFromClass(type(of: view)))
        }
        
        weak var weakSelf = self
        self.doraemon_showActionSheetWithTitle(title: "Parent Views", actions: actions, currentAction: nil) { (index) in
            weakSelf?.setNewSelectView(view: parentViews[index])
        }
    }
    
    func showSubviewSheet(_ selectView: UIView) {
        let actions = NSMutableArray()
        
        let subviews = findSubviewsBySelectedView(selectedView: selectView)
        
        for view in subviews {
            actions.add(NSStringFromClass(type(of: view)))
        }
        
        weak var weakSelf = self
        self.doraemon_showActionSheetWithTitle(title: "Subviews", actions: actions, currentAction: nil) { (index) in
            weakSelf?.setNewSelectView(view: subviews[index])
        }
    }
    
    func setNewSelectView(view: UIView) {
        doraemonHierarchyView(view: pickerView, didMoveTo: [view])
    }
}

public extension UIViewController {
    func doraemon_showActionSheetWithTitle(title: String? = nil, actions: NSMutableArray? = nil, currentAction: String? = nil, completion: ((Int) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        
        for (index, actionName) in (actions ?? []).enumerated() {
            let actionTitle = actionName as? String ?? ""
            let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
                completion?(index)
            }
            
            if currentAction == actionTitle {
                action.isEnabled = false
                action.setValue(DKImage(named: "doraemon_hierarchy_select"), forKey: "image")
            }
            
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
