//
//  IWTabBarItem.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/15.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWTabBarItem: UITabBarItem{
    
//    var index: Int = 0
    
    override var badgeValue: String? { //override 是从你烦继承过来的实例变量
        didSet{
            //didSet 设置完后再调用
            setBadgeViewBackgroundImage()
        }
    }
    
    
    private func setBadgeViewBackgroundImage()
    {
        //---------------拿到显示 badgeValue 的控件----------
        
        
        let target = self.valueForKeyPath("_target") as! UITabBarController
        
        //遍历 tabBar 的子控件
        for tabBarChild in target.tabBar.subviews {
            //拿到 UITabBarButton
            if tabBarChild.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                //遍历 UITabBarButton  的子控件
                for tabBarButtonChild in tabBarChild.subviews {
                    //拿到_UIBadgeView
                    if tabBarButtonChild.isKindOfClass(NSClassFromString("_UIBadgeView")!) {
                        //遍历_UIBadgeView 的子控件
                        for badgeViewChild in tabBarButtonChild.subviews {
                            //拿到_UIBadgeBackground
                            if badgeViewChild.isKindOfClass(NSClassFromString("_UIBadgeBackground")!) {
                                //------------利用运行时 获取 bagdeView的实例变量  KVC给实例变量赋值
                                //获取类的实例变量列表
                                var count : UInt32 = 0
                                let ivars = class_copyIvarList(NSClassFromString("_UIBadgeBackground"), &count)
                                //遍历实例变量列表
                                for i in 0..<count {
                                    //获取一个实例变量
                                    let ivar = ivars[Int(i)]
                                    //获取 ivar的名称
                                    let ivarName = NSString(CString: ivar_getName(ivar), encoding: NSUTF8StringEncoding)
                                    //获取 ivar的类型
                                    let ivarType = NSString(CString: ivar_getTypeEncoding(ivar), encoding: NSUTF8StringEncoding)
                                    printLog("name=\(ivarName);type=\(ivarType)") //打印结果 name=Optional(_image);type=Optional(@"UIImage")
                                    
                                    //当ivarName是 _image 的时候 用 KVC给类的属性进行赋值
                                    if ivarName!.isEqualToString("_image") {
                                        badgeViewChild.setValue(UIImage(named: "main_badge"), forKeyPath: "_image")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


