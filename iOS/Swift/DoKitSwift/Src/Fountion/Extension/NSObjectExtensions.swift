//
//  NSObjectExtensions.swift
//  DoraemonKit-Swift
//
//  Created by 邓锋 on 2020/5/29.
//

import Foundation

extension NSObject {
    static func swizzle(originalSelector: Selector, swizzledSelector: Selector){
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}

/// DoraemonHierarchy
extension NSObject {
    func dicFromString(string: String) -> CFDictionary {
        guard string.components(separatedBy: ":").count >= 2 else {
            return [:] as CFDictionary
        }
        
        let arr = string.components(separatedBy: " ").map { (string) -> String in
            return string.replacingOccurrences(of: ":", with: "")
        }.filter { !$0.isEmpty }

        let dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, nil, nil)
        
        for (index, str) in arr.enumerated() {
            /// 奇数项为key(index为偶数)
            guard index.isMultiple(of: 2) else {
                continue
            }
            
            let key = Unmanaged.passRetained(str as NSString).autorelease().toOpaque()
            let value = Unmanaged.passUnretained(arr[index + 1] as NSString).autorelease().toOpaque()
            CFDictionaryAddValue(dict, key, value)
        }
        return dict ?? [:] as CFDictionary
    }
    
    func doraemon_hierarchyCategoryModels() -> [HierarchyCategoryModel] {
        var settings = [HierarchyCellModel]()
        
        let model1 = HierarchyCellModel(title: "Frame", detailTitle: NSStringFromClass(type(of: self))).noneInsets()
        settings.append(model1)
        
        let model2 = HierarchyCellModel(title: "Address", detailTitle: String(format: "%p", self)).noneInsets()
        settings.append(model2)
        
        let model3 = HierarchyCellModel(title: "Description", detailTitle: self.description).noneInsets()
        settings.append(model3)
        
        return [HierarchyCategoryModel(title: "Object", items: settings)]
    }
    
    func doraemon_hierarchySizeDescription(size: CGSize) -> String {
        return String(format: "W: %@   H: %@", HierarchyFormatterTool.formatNumber(number: NSNumber(floatLiteral: Double(size.width))), HierarchyFormatterTool.formatNumber(number: NSNumber(floatLiteral: Double(size.height))))
    }
    
    func doraemon_hierarchyPointDescription(_ point: CGPoint) -> String {
        return String(format: "X: %@   Y: %@", HierarchyFormatterTool.formatNumber(number: NSNumber(floatLiteral: Double(point.x))), HierarchyFormatterTool.formatNumber(number: NSNumber(floatLiteral: Double(point.y))))
    }
    
    func doraemon_pointFromString(string: String, orginalPoint: CGPoint) -> CGPoint {
        let pointDic = dicFromString(string: string)
        return CGPoint(dictionaryRepresentation: pointDic) ?? CGPoint.zero
    }
    
    func hashColor() -> UIColor {
        let hue: CGFloat = CGFloat(Double((self.hash >> 4) % 256) / 255.0)
        return UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    func doraemon_showFrameAlertAndAutomicSet(keyPath: String) {
        let value: NSValue = self.value(forKeyPath: keyPath) as! NSValue
        
        weak var weakSelf = self
        doraemon_showTextFieldAlert(text: value.cgRectValue.dictionaryRepresentation) { (newText) in
//            weakSelf?.setValue(NSNumber(pointer: weakSelf!.doraemon_rectFromString(rectRepresentation: [] as! CFDictionary, originalRect: value.cgRectValue)), forKeyPath: keyPath)
        }
        
    }
    
    func doraemon_showTextFieldAlert(text: CFDictionary, handler: (_ newText: String) -> Void) {
        
    }
    
    func doraemon_rectFromString(string: String, originalRect rect: CGRect) -> CGRect {
        let rectRepresentation = dicFromString(string: string)
        let newRect = CGRect(dictionaryRepresentation: rectRepresentation) ?? CGRect.zero
        if CGRect.zero.equalTo(newRect) && (rectRepresentation != CGRect.zero.dictionaryRepresentation) {
            // Wrong text.
            return rect
        }
        return newRect
    }
    
    func doraemon_sizeFromString(string: String, originalSize size: CGSize) -> CGSize {
        let sizeRepresentation = dicFromString(string: string)
        let newSize = CGSize(dictionaryRepresentation: sizeRepresentation) ?? CGSize.zero
        if CGSize.zero.equalTo(newSize) && (sizeRepresentation != CGSize.zero.dictionaryRepresentation) {
            // Wrong text.
            return size
        }
        return newSize
    }
    
    func doraemon_insetsFromString(string: String, originalInsets insets: UIEdgeInsets) -> UIEdgeInsets {
        let insetsRepresentation = dicFromString(string: string)
        
        let key = Unmanaged.passRetained("top" as NSString).autorelease().toOpaque()

        let p = CFDictionaryGetValue(insetsRepresentation, key)
        
        let result = CGFloat(Unmanaged<NSString>.fromOpaque(p!).takeUnretainedValue().floatValue)
        
        let newInsets = UIEdgeInsets(top: result, left: result, bottom: result, right: result)
        if UIEdgeInsets.zero == newInsets {
            // Wrong text.
            return insets
        }
        return newInsets
    }
}

extension UIView {
    func doraemon_sizeHierarchyCategoryModels() -> [HierarchyCategoryModel] {
        var settings = [HierarchyCellModel]()
           
        weak var weakSelf = self
        let model1 = HierarchyCellModel(title: "Frame", detailTitle: doraemon_hierarchyPointDescription( self.frame.origin)).noneInsets()
        model1.block = {
            weakSelf?.doraemon_showFrameAlertAndAutomicSet(keyPath: "frame")
        }
        settings.append(model1)
           
        let model2 = HierarchyCellModel(title: nil, detailTitle: doraemon_hierarchySizeDescription(size: self.frame.size)).noneInsets()
        settings.append(model2)
           
        let model3 = HierarchyCellModel(title: "Bounds", detailTitle: doraemon_hierarchyPointDescription( self.bounds.origin)).noneInsets()
        model3.block = {
            weakSelf?.doraemon_showFrameAlertAndAutomicSet(keyPath: "bounds")
        }
        settings.append(model3)
        
        return [HierarchyCategoryModel(title: "View", items: settings)]
    }
}
