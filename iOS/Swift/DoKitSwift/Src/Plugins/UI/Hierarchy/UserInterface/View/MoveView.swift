//
//  MoveView.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class MoveView: UIView {
    var isOverflow = false
    var isMoved = false
    
    private var _isMoveable = false
    
    var isMoveable: Bool {
        set {
            if _isMoveable != newValue {
                _isMoveable = newValue
                self.panGestureRecognizer?.isEnabled = newValue
            }
        }
        get {
            return _isMoveable
        }
    }
    
    var moveableRect = CGRect.null
    
    private var moved = false
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
 
    open func initUI() {
        isMoveable = true
        moveableRect = CGRect.null
        // Pan, to moveable.
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGR(sender:)))
        self.addGestureRecognizer(panGestureRecognizer!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func viewWillUpdateOffset(sender: UIPanGestureRecognizer, offset: CGPoint) {
        
    }
    
    open func viewDidUpdateOffset(sender: UIPanGestureRecognizer, offset: CGPoint) {
        
    }
    
    @objc private func panGR(sender: UIPanGestureRecognizer) {
        if !isMoved {
            moved = true
        }
        
        let offsetPoint = sender.translation(in: self)
        self.viewWillUpdateOffset(sender: sender, offset: offsetPoint)
        sender.setTranslation(offsetPoint, in: sender.view)
        self.changeFrameWithPoint(point: offsetPoint)
        self.viewDidUpdateOffset(sender: sender, offset: offsetPoint)
    }
    
    private func changeFrameWithPoint(point: CGPoint) {
        var center = self.center
        
        center.x += point.x
        center.y += point.y
        
        let superViewWidth = superview?.width ?? 0
        let superViewHeight = superview?.height ?? 0
        
        if isOverflow {
            center.x = min(center.x, superViewWidth)
            center.y = min(center.y, superViewHeight)
        } else {
            if (center.x < width / 2.0) {
                center.x = width / 2.0;
            } else if (center.x > superViewWidth - width / 2.0) {
                center.x = superViewWidth - width / 2.0;
            }
            
            if (center.y < height / 2.0) {
                center.y = height / 2.0;
            } else if (center.y > superViewHeight - height / 2.0) {
                center.y = superViewHeight - height / 2.0;
            }
        }
        
        if CGRect.null != moveableRect, moveableRect.contains(center) {
            if (center.x < moveableRect.origin.x) {
                center.x = moveableRect.origin.x;
            } else if (center.x > moveableRect.origin.x + moveableRect.size.width) {
                center.x = moveableRect.origin.x + moveableRect.size.width;
            }
            if (center.y < moveableRect.origin.y) {
                center.y = moveableRect.origin.y;
            } else if (center.y > moveableRect.origin.y + moveableRect.size.height) {
                center.y = moveableRect.origin.y + moveableRect.size.height;
            }
        }
        
        self.center = center
    }
}
