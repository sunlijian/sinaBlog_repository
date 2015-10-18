//
//  IWTarBar.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/9.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWTarBar: UITabBar {
    
    
    var plusButton :UIButton?
    
    //定义一个点击执行的闭包
    var plusBtnClick : (()->())?
    
    //先进行初始化
    override init(frame: CGRect) {
        //先把父类的初始化
        super.init(frame: frame)
        
        //创建 plusButton
        let plusButton = UIButton()
        //设置 plusButton 的背景图片
        plusButton.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        plusButton.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        //设置 plusButton 的图片
        plusButton.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        plusButton.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        //添加点击事件
        plusButton.addTarget(self, action: "clickPlusButton", forControlEvents: UIControlEvents.TouchUpInside)
        //设置大小
        plusButton.sizeToFit()
        //添加 plusButton
        addSubview(plusButton)
        //
        self.plusButton = plusButton
    }
    
    
    //给 tabBar 里的控件布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //计算 plusButton 的位置
        self.plusButton?.center = CGPointMake(self.center.x, self.frame.size.height * 0.5)
        
        //计算其他四个的位置
        var index = 0
        let childW = frame.size.width / 5
        for childView in subviews {
            if childView.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                childView.width = childW
                childView.x = CGFloat(index) * childW
                
                index++
                
                if index == 2 {
                    index++
                }
            }
        }
    }
    
    //按钮的点击事件
    @objc private func clickPlusButton(){
        if let block = plusBtnClick {
            block()
        }
    }
    
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
