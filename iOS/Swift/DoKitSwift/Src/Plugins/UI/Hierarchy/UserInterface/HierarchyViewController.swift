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

class HierarchyViewController: UIViewController {
    var delegate: HierarchyInfoViewDelegate?
    var observeViews: Set<UIView>?
    var borderViews: Dictionary<NSNumber, UIView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    func beginObserveView(view: UIView, borderWidth: CGFloat) {
        guard self.observeViews?.contains(view) == true else {
            return
        }
        
        let borderView = UIView()
        borderView.backgroundColor = .clear
        view.addSubview(borderView)
        view.sendSubviewToBack(borderView)
        // TODO: doraemon_hashColor
        borderView.layer.borderColor = view.backgroundColor?.cgColor
        borderView.layer.borderWidth = borderWidth
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
}

//for (UIView *view in self.observeViews) {
//    [self stopObserveView:view];
//}
//[self.observeViews removeAllObjects];
//
//for (NSInteger i = selectedViews.count - 1; i >= 0; i--) {
//    UIView *view = selectedViews[i];
//    CGFloat borderWidth = 1;
//    if (i == selectedViews.count - 1) {
//        borderWidth = 2;
//    }
//    [self beginObserveView:view borderWidth:borderWidth];
//}
//[self.observeViews addObjectsFromArray:selectedViews];

extension HierarchyViewController: HierarchyInfoViewDelegate {
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
    
    func doraemonHierarchyInfoViewDidSelectCloseButton(view: HierarchyInfoView) {
        
    }
    
    func doraemonHierarchyInfoView(view: HierarchyInfoView, didSelectAt action: HierarchyInfoViewAction) {
        
    }
}
