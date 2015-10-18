//
//  IWComposeButton.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/18.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

let COMPOSE_BUTTON_W: CGFloat = 80
let COMPOSE_BUTTON_H: CGFloat = 110

class IWComposeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //大小
        size = CGSizeMake(COMPOSE_BUTTON_W, COMPOSE_BUTTON_H)
        //button 的 imageView
        imageView?.contentMode = UIViewContentMode.Center
        //设置titile
        titleLabel?.textAlignment = NSTextAlignment.Center
        titleLabel?.font = UIFont.systemFontOfSize(14)
        setTitleColor(RGB(r: 100, g: 100, b: 100), forState: UIControlState.Normal)
    }
    //设置位置
    override func layoutSubviews() {
        super.layoutSubviews()
        //图位置
        imageView!.x = 0
        imageView!.y = 0
        imageView?.width = self.width
        imageView?.height = self.width
        //label 位置
        titleLabel!.x = 0
        titleLabel?.y = self.width
        titleLabel?.width = self.width
        titleLabel?.height = self.height - self.width
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
