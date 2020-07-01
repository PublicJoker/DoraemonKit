//
//  HierarchyHelper.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyHelper: NSObject {
    static let shared = HierarchyHelper()
    
    var window: HierarchyWindow?
    
    var isHierarchyIgnorePrivateClass: Bool = true
    
    public func allWindows() -> [UIWindow]? {
        return allWindowsIgnorePrefix(prefix: nil)
    }
    
    public func allWindowsIgnorePrefix(prefix: String?) -> [UIWindow]? {
        let allWindows = UIApplication.shared.windows
        
        if prefix?.isEmpty == true {
            return allWindows.sorted { $0.windowLevel > $1.windowLevel }
        }
        
        /// 过滤以prefix开头的window,并按windowLevel降序排列
        return allWindows.filter { !NSStringFromClass(type(of: $0)).hasPrefix(prefix!) }.sorted { $0.windowLevel > $1.windowLevel }
    }
}
