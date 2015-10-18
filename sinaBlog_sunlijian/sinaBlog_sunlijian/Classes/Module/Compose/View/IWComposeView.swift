//
//  IWComposeView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/18.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
let COMPOSE_BUTTON_MAGIN: CGFloat = (SCREEN_W - 3*COMPOSE_BUTTON_W) / 4
class IWComposeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置大小
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H)
        //添加背景图片
        let imageView = UIImageView(image: screenImage())
        imageView.size = size
        addSubview(imageView)
        //添加 button
        addMeumButton()
        //添加compose_slogan
        addCompose_sloganImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //屏幕载图
    private func screenImage() -> UIImage{
        //取出 window
        let window = UIApplication.sharedApplication().keyWindow
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_W, SCREEN_H), false, 0)
        //把当前 window 显示的图形添加到上下文中
        window?.drawViewHierarchyInRect(window!.bounds, afterScreenUpdates: false)
        //获取图片
        var image = UIGraphicsGetImageFromCurrentImageContext()
        //进行模糊渲染
        image = image.applyLightEffect()
        //关闭图形上下文
        UIGraphicsEndImageContext()
        
        return image
    }
    //添加 button
    private func addMeumButton(){
        //解析 plist 文件
        let path = NSBundle.mainBundle().pathForResource("compose", ofType: "plist")
        let composeButtonInfos = NSArray(contentsOfFile: path!)
        //遍历添加 button
        for i in 0..<composeButtonInfos!.count{
            //创建 button
            let buttonInfo = IWComposeButton()
            //取出字典
            let info = composeButtonInfos![i] as! [String: AnyObject]
            //给 button 赋值
            buttonInfo.setImage(UIImage(named: (info["icon"] as! String)), forState: UIControlState.Normal)
            buttonInfo.setTitle((info["title"] as! String), forState: UIControlState.Normal)
            //设置 button 的 位置
            let rowIndex = i / 3
            let colIndex = i % 3
            buttonInfo.x = CGFloat(colIndex) * COMPOSE_BUTTON_W + CGFloat(colIndex + 1) * COMPOSE_BUTTON_MAGIN
            buttonInfo.y = CGFloat(rowIndex) * COMPOSE_BUTTON_H + CGFloat(rowIndex + 1) * COMPOSE_BUTTON_MAGIN + SCREEN_H
            print(buttonInfo.x)
            //添加到当前 view 上
            addSubview(buttonInfo)
        }
    }
    
    func show(){
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismiss()
    }
    
    func dismiss(){
        removeFromSuperview()
    }
    
    private func addCompose_sloganImage(){
        addSubview(sloganImage)
    }
    
    private lazy var sloganImage : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "compose_slogan"))
        imageView.centerX = SCREEN_W * 0.5
        imageView.y = 100
        return imageView
    }()
    
}
