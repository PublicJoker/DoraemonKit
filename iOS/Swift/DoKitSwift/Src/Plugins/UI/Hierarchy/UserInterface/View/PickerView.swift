//
//  PickerView.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class PickerView: MoveView {
    override func initUI() {
        super.initUI()
        
        self.isOverflow = true
        self.backgroundColor = .clear
        self.layer.cornerRadius = self.width / 2.0
        self.layer.masksToBounds = true
        
        let imageView = UIImageView(image: DKImage(named: "doraemon_visual"))
        imageView.frame = self.bounds
        self.addSubview(imageView)
    }
}
