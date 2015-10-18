//
//  IWHomeTitleButton.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/11.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWHomeTitleButton: UIButton {
    
    //调整子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //设置titleLabel
        titleLabel!.x = 0
        
        imageView?.x = CGRectGetMaxX(titleLabel?.frame ?? CGRectZero) + 5
    }
    
    //先调整 整个 titleView 的大小
    override func sizeToFit() {
        super.sizeToFit()
        width += 5
    }
}
