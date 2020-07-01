//
//  HierarchyCategoryModel.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyCategoryModel: NSObject {
    var title: String?
    var items: [HierarchyCellModel]?
    
    init(title: String? = nil, items: [HierarchyCellModel]? = nil) {
        self.title = title
        self.items = items
    }
}
