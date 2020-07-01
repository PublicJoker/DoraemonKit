//
//  UIProfilePlugin.swift
//  DoraemonKit-Swift
//
//  Created by jiaruh on 2020/6/22.
//

import Foundation

struct UIProfilePlugin { }

extension UIProfilePlugin: Plugin {
    var module: PluginModule {
        .performance
    }
    
    var title: String {
        LocalizedString("UI层级")
    }
    
    var icon: UIImage? {
        DKImage(named: "doraemon_view_level")
    }
    
    func onInstall() {
        UIViewController.swizzle(originalSelector: #selector(UIViewController.viewDidAppear(_:)), swizzledSelector: #selector(UIViewController.dokit_viewDidAppear(_:)))
        
        UIViewController.swizzle(originalSelector: #selector(UIViewController.viewWillDisappear(_:)), swizzledSelector: #selector(UIViewController.dokit_viewWillDisappear(_:)))
    }
    
    func onSelected() {
        HomeWindow.shared.openPlugin(vc: UIProfileViewController())
    }
    
}
