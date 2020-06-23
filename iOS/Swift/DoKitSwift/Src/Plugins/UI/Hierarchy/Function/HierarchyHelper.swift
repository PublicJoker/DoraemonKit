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
        var includeInternalWindows = true
        var onlyVisibleWindows = false
        
        let allWindowsSelector = NSSelectorFromString("allWindowsIncludingInternalWindows:onlyVisibleWindows:")
        return []
    }
    
    
    // 动态方法解析
    override class func resolveInstanceMethod(_ sel: Selector!) -> Bool {
        class_getClassMethod(self, #selector(runIMP))
        guard let method = class_getInstanceMethod(self, #selector(runIMP))  else {
            return super.resolveInstanceMethod(sel)
        }
        return class_addMethod(self, Selector("run"), method_getImplementation(method), method_getTypeEncoding(method))
    }
    
    @objc func runIMP() {
        print("runIMP")
    }
    
    // 快速消息转发
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return nil
    }
}

class Test : NSObject
{
//    @objc var name : String? {
//     didSet {
//      NSLog("didSetCalled")
//     }
//    }
    
    @objc func name(n: String?) -> Bool {
        NSLog("didSetCalled")
        return true
    }

    func invocationTest() {
        let invocation : NSObject = unsafeBitCast(method_getImplementation(class_getClassMethod(NSClassFromString("NSInvocation"), NSSelectorFromString("invocationWithMethodSignature:"))!),to:(@convention(c)(AnyClass?,Selector,Any?)->Any).self)(NSClassFromString("NSInvocation"),NSSelectorFromString("invocationWithMethodSignature:"),unsafeBitCast(method(for: NSSelectorFromString("methodSignatureForSelector:"))!,to:(@convention(c)(Any?,Selector,Selector)->Any).self)(self,NSSelectorFromString("methodSignatureForSelector:"),#selector(name(n:)))) as! NSObject
        unsafeBitCast(class_getMethodImplementation(NSClassFromString("NSInvocation"), NSSelectorFromString("setSelector:")),to:(@convention(c)(Any,Selector,Selector)->Void).self)(invocation,NSSelectorFromString("setSelector:"),#selector(name(n:)))
        var localName = name
        withUnsafePointer(to: &localName) { unsafeBitCast(class_getMethodImplementation(NSClassFromString("NSInvocation"), NSSelectorFromString("setArgument:atIndex:")),to:(@convention(c)(Any,Selector,OpaquePointer,NSInteger)->Void).self)(invocation,NSSelectorFromString("setArgument:atIndex:"), OpaquePointer($0),2) }
        invocation.perform(NSSelectorFromString("invoke"))
        
        var windows: [UIWindow] = []
//
//       let result = invocation.perform(NSSelectorFromString("getReturnValue:"), with: windows)
//        print(result)
//
        invocation.perform(NSSelectorFromString("getReturnValue:"), with: windows)
        
        let value = invocation.perform(NSSelectorFromString("getReturnValue:")) //type of value is Unmanaged<AnyObject?>
        let uvalue = value!.takeUnretainedValue() //type of uvalue is now AnyObject?
    }
}
