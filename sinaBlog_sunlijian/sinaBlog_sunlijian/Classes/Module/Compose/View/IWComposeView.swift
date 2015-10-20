//
//  IWComposeView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/18.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
import pop
let COMPOSE_BUTTON_MAGIN: CGFloat = (SCREEN_W - 3*COMPOSE_BUTTON_W) / 4
class IWComposeView: UIView {
    
    var targetVC : UIViewController?

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
            //添加监听事件
            buttonInfo.addTarget(self, action: "composeButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
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
            //添加到数组中
            composeButtons.append(buttonInfo)
        }
    }
    //点击加号按钮
    func show(target:UIViewController){
        
        target.view.addSubview(self)
        self.targetVC = target
        
        //添加动画
        for (index, value) in composeButtons.enumerate(){
             anmi(value, centerY: value.centerY - 400, index: index)
        }
        
    }
    //点击屏幕消失
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismiss()
    }
    func dismiss(){
        
        for (index, value) in composeButtons.reverse().enumerate(){
            
            anmi(value, centerY: value.centerY + 400, index: index)

        }
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.removeFromSuperview()
        }
    }
    //初始化添加顶部控件到 view 上
    private func addCompose_sloganImage(){
        addSubview(sloganImage)
    }
    //懒加载顶部的 logo控件
    private lazy var sloganImage : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "compose_slogan"))
        imageView.centerX = SCREEN_W * 0.5
        imageView.y = 100
        return imageView
    }()
    //button 数组的懒加载
    private lazy var composeButtons :[IWComposeButton] = [IWComposeButton]()
    
    
    //button 的点击事件
    @objc private func composeButtonClick(button: IWComposeButton){
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            //改变 button 的 transform
            for value in self.composeButtons{
                if value == button {
                    value.transform = CGAffineTransformMakeScale(2, 2)
                }else{
                    value.transform = CGAffineTransformMakeScale(0, 0)
                }
                value.alpha = 0
            }
        }) { (finish) -> Void in
            

            let vc = IWComposeViewController()
            let nv =  IWNavigationController(rootViewController: vc)
            self.targetVC?.presentViewController(nv, animated: true, completion: { () -> Void in
                self.removeFromSuperview()
            })
        }
    }
    //动画
    private func anmi(value:UIButton, centerY:CGFloat, index: Int){
        //初始化一个弹性动画对象
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        anim.toValue = NSValue(CGPoint: CGPointMake(value.centerX, centerY))
        //动画的弹性幅度
        anim.springBounciness = 10
        //动画的速度
        anim.springSpeed = 10
        //动画的执行时间(相对于现在来说 向后延迟多少秒)
        anim.beginTime = CACurrentMediaTime() + Double(index) * 0.025
        //给控件添加动画对象
        value.pop_addAnimation(anim, forKey: nil)
    }
    
}
