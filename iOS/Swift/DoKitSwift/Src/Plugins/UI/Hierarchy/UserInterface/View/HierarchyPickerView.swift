//
//  HierarchyPickerView.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

protocol HierarchyViewDelegate: NSObjectProtocol {
    func doraemonHierarchyView(view: HierarchyPickerView, didMoveTo selectedViews: [UIView])
}

class HierarchyPickerView: PickerView {
    weak var delegate: HierarchyViewDelegate?
    
    //MARK: - Over write
    override func viewDidUpdateOffset(sender: UIPanGestureRecognizer, offset: CGPoint) {
        let views = viewForSelectionAtPoint(tapPointInWindow: center)
        self.delegate?.doraemonHierarchyView(view: self, didMoveTo: views)
    }
    
    //MARK: - Primary
    private func viewForSelectionAtPoint(tapPointInWindow: CGPoint) -> [UIView] {
        var windowForSelection = UIApplication.shared.keyWindow

        for window in HierarchyHelper.shared.allWindowsIgnorePrefix(prefix: "Doraemon")?.reversed() ?? [] {
            if window.hitTest(tapPointInWindow, with: nil) != nil {
                windowForSelection = window
                break
            }
        }
        
        return recursiveSubviewsAtPoint(tapPointInWindow, inView: windowForSelection!, skipHiddenViews: true)
    }
    
    private func recursiveSubviewsAtPoint(_ pointInView: CGPoint, inView view: UIView, skipHiddenViews skipHidden: Bool) -> [UIView] {
        var subviewsAtPoint: [UIView] = []
        
        for subview in view.subviews {
            let isHidden = subview.isHidden || subview.alpha < 0.01
            
            if skipHidden && isHidden {
                continue
            }
            
            let subviewContainsPoint = subview.frame.contains(pointInView)
            if subviewContainsPoint {
                subviewsAtPoint.append(subview)
            }
            
            // If this view doesn't clip to its bounds, we need to check its subviews even if it doesn't contain the selection point.
            // They may be visible and contain the selection point.
            if (subviewContainsPoint || !subview.clipsToBounds) {
                let pointInSubview = view.convert(pointInView, to: subview)
                subviewsAtPoint.append(contentsOf: recursiveSubviewsAtPoint(pointInSubview, inView: subview, skipHiddenViews: skipHidden))
            }
        }
        
        return subviewsAtPoint
    }
}
