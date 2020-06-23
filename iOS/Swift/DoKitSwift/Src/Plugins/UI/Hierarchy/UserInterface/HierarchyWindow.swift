//
//  HierarchyWindow.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

import UIKit

class HierarchyWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if true {
                    self.windowScene = windowScene as? UIWindowScene
                    break
                }
            }
        } else {
            // Fallback on earlier versions
        }
        self.windowLevel = UIWindow.Level.alert - 1 

        
        if self.rootViewController == nil {
            self.rootViewController = HierarchyViewController()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        self.isHidden = false
    }
    
    public func hide() {
        self.isHidden = true
    }
}

