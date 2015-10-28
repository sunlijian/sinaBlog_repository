//
//  IWEmotionToolBar.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/23.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

enum IWEmotionToolBarButtonType: Int{
    case Recent = 1000
    case Default = 1001
    case Emoji = 1002
    case Lxh = 1003
}

protocol IWEmotionToolBarDelegate: NSObjectProtocol{
    func emotionToolBar(toolBar: IWEmotionToolBar, type: IWEmotionToolBarButtonType)
}

class IWEmotionToolBar: UIView {
    
    //
    var selectedButton: UIButton?
    //代理
    weak var delegate: IWEmotionToolBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加按钮
        let recentBtn = addChild("compose_emotion_table_left", title: "最近", type: .Recent)
        addChild("compose_emotion_table_mid", title: "默认", type: .Default)
        addChild("compose_emotion_table_mid", title: "Emoji", type: .Emoji)
        addChild("compose_emotion_table_right", title: "浪小花", type: .Lxh)
        
        childButtonClick(recentBtn)
        
        
        
    }
    //添加 toolBar 的 button
    private func addChild(imageName: String, title: String, type: IWEmotionToolBarButtonType) -> IWEmotionToolBarButton{
        let button = IWEmotionToolBarButton()
        //添加点击事件
        button.addTarget(self, action: "childButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        //设置文字
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Selected)
        //设置背景图片
        button.setBackgroundImage(UIImage(named: "\(imageName)_normal"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "\(imageName)_selected"), forState: UIControlState.Selected)
        //设置 button 的 tag
        button.tag = type.rawValue
        
        addSubview(button)
        
        return button
    }
    //button 的点击事件
    @objc private func childButtonClick(button: UIButton){
        
        if selectedButton == button {
            return
        }
        
        selectedButton?.selected = false
        button.selected = true
        selectedButton = button
        
        if let dele = delegate {
            dele.emotionToolBar(self, type: IWEmotionToolBarButtonType(rawValue: button.tag)!)
        }
        
    }
    //根据button 的类型来改变 button 的选中状态
    func selectedButtonWithType(type: IWEmotionToolBarButtonType){
        //当前 type 类型的 button
        let button = viewWithTag(type.rawValue) as! UIButton
        
        if selectedButton == button {
            return
        }
        
        selectedButton?.selected = false
        button.selected = true
        selectedButton = button
    }
    
    
    //子控件的位置与大小
    override func layoutSubviews() {
        super.layoutSubviews()
        //计算子控件的宽度
        let childWH = width / CGFloat(subviews.count)
        
        for (index, value) in subviews.enumerate(){
            value.x = childWH * CGFloat(index)
            value.height = height
            value.width = childWH
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
