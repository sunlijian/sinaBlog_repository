//
//  IWComposeToolBar.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/21.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

enum ButtonType: Int{
    case Picture = 0
    case Mention = 1  //@
    case Trend = 2    //话题
    case Emotion = 3
    case Add = 4
}

//代理
protocol IWComposeToolBarDelegate: NSObjectProtocol{
    func composeToolBarButtonDidClick(toolBar: IWComposeToolBar, type: ButtonType)
}

class IWComposeToolBar: UIView {

    //代理属性
    weak var delegate: IWComposeToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //背景色
        backgroundColor = UIColor(patternImage: UIImage(named: "compose_toolbar_background")!)
        
        //给 toolBar 添加按钮
        addChildButton("compose_toolbar_picture", type: .Picture)
        addChildButton("compose_mentionbutton_background", type: .Mention)
        addChildButton("compose_trendbutton_background", type: .Trend)
        addChildButton("compose_emoticonbutton_background", type: .Emotion)
        addChildButton("compose_add_background", type: .Add)
        
        
    }
    
    private func addChildButton(imageName: String, type: ButtonType){
        let button = UIButton()
        //添加监听事件
        button.addTarget(self, action: "composeToolBarButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        //设置类型标识
        button.tag = type.rawValue
        //设置图片
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        self.addSubview(button)
    }
    //设置子控件的位置和大小
    override func layoutSubviews() {
        super.layoutSubviews()
        //按钮的的宽度
        let buttonW = SCREEN_W / CGFloat(subviews.count)
        
        for (index, value) in subviews.enumerate(){
            value.x = CGFloat(index) * buttonW
            value.height = height
            value.width = buttonW
        }
    }
    //按钮的点击事件
    @objc private func composeToolBarButtonClick(button: UIButton){
        if let dele = delegate{
            dele.composeToolBarButtonDidClick(self, type: ButtonType(rawValue: button.tag)!)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
