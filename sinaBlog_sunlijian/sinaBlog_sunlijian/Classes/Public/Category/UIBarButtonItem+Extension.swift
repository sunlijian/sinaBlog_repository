//
//  UIBarButtonItem+Extension.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/9.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import Foundation
import UIKit
extension UIBarButtonItem{
    
    //给 UIBarButtonItem分类添加一个方法 返回一个 UIBarButtonItem对象
    class func item(imageName: String = "", title: String = "", target: AnyObject?, action: Selector)->UIBarButtonItem {
        //创建一个 button
        let button = UIButton()
        //添加点击事件
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        //添加图片
        if imageName.characters.count > 0 {
            button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        }
        
        //添加字体
        if title.characters.count > 0 {
            button.setTitle(title, forState: UIControlState.Normal)
            
            //设置字体大小
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            
            //设置字体颜色
            button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
        }
        
        //调整一下
        button.sizeToFit()
        
        return UIBarButtonItem(customView: button)
    }
    
}