//
//  HierarchyFormatterTool.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyFormatterTool: NSObject {
    static let shared = HierarchyFormatterTool()
    
    lazy var numberFormatter: NumberFormatter = {
        $0.numberStyle = .decimal
        $0.maximumFractionDigits = 2
        $0.usesGroupingSeparator = false
        return $0
    }(NumberFormatter())
    
    /**
    Format print frame with maximumFractionDigits = 2.
    
    @param frame CGRect.
    @return Format string.
    */
    class func stringFromFrame(frame: CGRect) -> String {
        return ""
    }
    
    /**
    Format a CGFloat value with maximumFractionDigits = 2.

    @param number NSNumber.
    @return Format string.
    */
    class func formatNumber(number: NSNumber) -> String {
        return self.shared.formatNumber(number: number)
    }
    
    
    // MARK: Primary
    func formatNumber(number: NSNumber) -> String {
        return ""
    }
}
