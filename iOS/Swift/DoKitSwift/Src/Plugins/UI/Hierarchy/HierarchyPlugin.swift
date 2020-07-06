//
//  HierarchyPlugin.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

import Foundation

class HierarchyPlugin: Plugin {
    var module: PluginModule { .ui }
    
    var title: String { LocalizedString("UI结构") }
    
    var icon: UIImage? { DKImage(named: "doraemon_view_level") }
    
    func onInstall() {
        
    }
    
    func onSelected() {
        let window = HierarchyWindow.init(frame: UIScreen.main.bounds)
        HierarchyHelper.shared.window = window
        window.show()
        HomeWindow.shared.hide()
    }
}
