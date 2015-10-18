//
//  IWStatusToolBar.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/16.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWStatusToolBar: UIView {
    
    var commentButton: UIButton?
    var retweetButton: UIButton?
    var attitudButton: UIButton?
    
    private lazy var buttons : [UIButton] = [UIButton]()
    private lazy var splites : [UIImageView] = [UIImageView]()
    
    var status: IWStatus?{
        didSet{
            setStatus()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加转发按钮
        retweetButton = addChild("timeline_icon_retweet", defaultTitle: "转发")
        //添加评论按钮
        commentButton = addChild("timeline_icon_comment", defaultTitle: "评论")
        //添加赞按钮
        attitudButton = addChild("timeline_icon_unlike", defaultTitle: "赞")
        
        //添加分割线
        addSpliteView()
        addSpliteView()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //添加 button
    private func addChild(imageName:String, defaultTitle:String) -> UIButton{
        let button = UIButton()
        //设置图片
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        //设置默认文字
        button.setTitle(defaultTitle, forState: UIControlState.Normal)
        
        //设置背景图片
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background_highlighted"), forState: UIControlState.Highlighted)
        //设置文字颜色
        button.setTitleColor(RGB(r: 80, g: 80, b: 80), forState: UIControlState.Normal)
        //设置字体大小
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        //设置图片偏移
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        //添加到 view 上
        addSubview(button)
        //添加到数组中
        buttons.append(button)
        return button
    }
    
    //添加分割线
    private func addSpliteView(){
        let imageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
        addSubview(imageView)
        splites.append(imageView)
    }
    
    
    //设置按钮的位置
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置每个按钮的宽度
        let childButtonW = width / CGFloat(buttons.count)
        for i in 0..<buttons.count{
            //设置按钮的 X 值
            let childButtonX = childButtonW * CGFloat(i)
            //设置按钮的 Y值
            let childButtonY :CGFloat = 0
            //设置按钮的 size
            let childSize = CGSizeMake(childButtonW, height)
            //设置按钮的 frame
            buttons[i].frame = CGRect(origin: CGPointMake(childButtonX, childButtonY), size: childSize)
        }
        
        //设置分割线的位置
        for i in 0..<splites.count{
            let spliteView = splites[i]
            spliteView.x = childButtonW * CGFloat(i + 1)
        }
    }
    //设置数据
    private func setStatus(){
        if let st = status {
            //设置转发数
            setCount(retweetButton!, count: st.reposts_count, defaultTitle: "转发")
            //设置评论数
            setCount(commentButton!, count: st.comments_count, defaultTitle: "评论")
            //设置赞数
            setCount(attitudButton!, count: st.attitudes_count, defaultTitle: "赞")
        }
    }
    
    private func setCount(button: UIButton, count: Int, defaultTitle: String){
        if count != 0{
            if count < 10000{
                button.setTitle("\(count)", forState: UIControlState.Normal)
            }else{
                let result = count / 1000
                var resultStr = "\(CGFloat(result)/CGFloat(10))"
                resultStr = resultStr.stringByReplacingOccurrencesOfString(".0", withString: "")
                button.setTitle(resultStr, forState: UIControlState.Normal)
            }
        }else{
            button.setTitle(defaultTitle, forState: UIControlState.Normal)
        }
    }
}
