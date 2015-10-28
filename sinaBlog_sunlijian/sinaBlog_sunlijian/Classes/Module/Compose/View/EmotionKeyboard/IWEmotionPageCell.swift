//
//  IWEmotionPageCell.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/23.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
//一页中最大行
let PAGE_EMOTION_MAX_ROW = 3
//一页中最大列
let PAGE_EMOTION_MAX_COL = 7
//一页中的表情数
let PAGE_EMOTION_MAX = PAGE_EMOTION_MAX_ROW * PAGE_EMOTION_MAX_COL - 1
class IWEmotionPageCell: UICollectionViewCell {
    
    
    var emotions: [IWEmotion]?{
        didSet{
            print(emotions!)
            //先隐藏所有按钮
            for value in emotionButtons{
                value.hidden = true
            }
            
            for (index, value) in emotions!.enumerate(){
                let button = emotionButtons[index]
                //显示按钮
                button.hidden = false
                //给 button添加一个 emotion 属性
                button.emotion = value
               
            }

        }
    }
    
    
    private lazy var emotionButtons : [IWEmotionButton] = [IWEmotionButton]()
    
    var indexPath: NSIndexPath?{
        didSet{
            recentLabel.hidden = indexPath?.row != 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        //添加最近的 label
        contentView.addSubview(recentLabel)
        
        //添加小图标
        for _ in 0..<PAGE_EMOTION_MAX {
            let emotionButton = IWEmotionButton()
            //添加点击事件
            emotionButton.addTarget(self, action: "emotionButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            emotionButton.titleLabel?.font = UIFont.systemFontOfSize(32)
            
            contentView.addSubview(emotionButton)
            //添加到表情集合中
            emotionButtons.append(emotionButton)
        }
        //添加删除图标
        contentView.addSubview(deleteButton)
        
        //添加长按手势
        let ges = UILongPressGestureRecognizer(target: self, action: "longPress:")
        addGestureRecognizer(ges)
        
    }
    //表情按钮点击事件
    @objc private func emotionButtonClick(button: IWEmotionButton){
        let emotion = button.emotion!
        //保存表情
        IWEmotionTools.saveEmotion(emotion)
        
        //发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(IWEmotionButtonDidSelectedNotification, object: nil, userInfo: ["IWEmotionNotifyKey": emotion])
        
        
    }
    //删除按钮的点击
    @objc private func deleteButtonClick(){
        //发送通知
    NSNotificationCenter.defaultCenter().postNotificationName("IWEmotionDeleteButtonDidSelectedNotification", object: nil, userInfo: nil)
    }
    
    
    
    //添加手势
    @objc private func longPress(ges: UIGestureRecognizer){
        
        //根据当前点击的点 返回一个 带有 emotion 属性的 button
        func buttonWithPoint(point: CGPoint) -> IWEmotionButton?{
            for value in emotionButtons{
                if value.emotion == nil || value.hidden == true  {
                    continue
                }
                if CGRectContainsPoint(value.frame, point) && value.hidden == false && value.isKindOfClass(IWEmotionButton) {
                    return value
                }
            }
            return nil
        }
        
        
        switch ges.state{
        case .Changed, .Began:
            popView.hidden = false
        

        default:
            popView.hidden = true
            return //最后放手的时候 直接让 popView 隐藏 并return不执行后面的代码 以保证 popView不会再次根据 value 的状态来确定是否隐藏
        }
        //获取当前长按手势的点
        let point = ges.locationInView(self)
        
        let button = buttonWithPoint(point)
        
        if button != nil{
//            popView.hidden = false
            //把value 的 frame转成对应 window上的点
            let window = UIApplication.sharedApplication().windows.last!
            let rect = button!.convertRect(button!.bounds, toView: window)
            //设置 popView 的位置
            popView.centerX = CGRectGetMidX(rect)
            popView.y = CGRectGetMaxY(rect) - popView.height
            //给 popView设置button
            popView.emotionButton.emotion = button!.emotion
        }else{
            popView.hidden = true
        }
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //最近使用页底部文字
        recentLabel.centerX = width * 0.5
        recentLabel.y = height - recentLabel.height - 5
        //表情按钮的宽度
        let emotionBtnW = width / CGFloat(PAGE_EMOTION_MAX_COL)
        //表情按钮的高度
        let margin: CGFloat = 40
        let emotionBtnH = (height - margin) / CGFloat(PAGE_EMOTION_MAX_ROW)
        for(index, value) in emotionButtons.enumerate(){
            //行列索引
            let colIndex = index % PAGE_EMOTION_MAX_COL
            let rowIndex = index / PAGE_EMOTION_MAX_COL
            //表情按钮的 x y
            let emotionBtnX = CGFloat(colIndex) * emotionBtnW
            let emotionBtnY = CGFloat(rowIndex) * emotionBtnH
            value.frame = CGRectMake(emotionBtnX, emotionBtnY, emotionBtnW, emotionBtnH)
        }
        
        //删除按钮的位置
        deleteButton.size = CGSizeMake(emotionBtnW, emotionBtnH)
        deleteButton.x = width - deleteButton.width
        deleteButton.y = height - deleteButton.height - margin
        
    }
    //懒加载最近的 label
    private lazy var recentLabel : UILabel = {
        let label = UILabel()
        //设置
        label.text = "最近使用的表情"
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.sizeToFit()
        return label
    }()
    //懒加载删除 button
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        //设置按钮图片
        button.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
        //添加监听事件
        button.addTarget(self, action: "deleteButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    //显示弹出的表情 popView
    private lazy var popView: IWEmotionPopView = {
        let popView = IWEmotionPopView.popView()
        
        popView.hidden = true
        
        let window = UIApplication.sharedApplication().windows.last!
        window.addSubview(popView)
        return popView
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
