//
//  IWPopView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/11.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
protocol IWPopViewDelegate: NSObjectProtocol {
    func popViewWillDismiss()
}

class IWPopView: UIButton {
    
    //设置代理属性
    weak var delegate: IWPopViewDelegate?
    
    var imageBack:UIImageView?

    init(customView: UIView){
        //初始化
        super.init(frame: CGRectMake(0, 0, SCREEN_W, SCREEN_H))
        //添加点击事件
        addTarget(self, action: "coverButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //设置弹窗
        setupView(customView)
    }
    
    //设置弹窗
    private func setupView(customView: UIView){
        //设置图片
        let image = UIImage(named: "popover_background")
        //设置 imageBack
        //拉伸图片
        let imageBack = UIImageView(image: image?.stretchableImageWithLeftCapWidth(Int(image!.size.width * 0.5), topCapHeight: Int(image!.size.height * 0.5)))
        imageBack.size = CGSizeMake(customView.width + 10, customView.height + 22)
        //添加到 IMAGEbACK
        addSubview(imageBack)
        self.imageBack = imageBack
        //添加 customView
        customView.x = 5
        customView.y = 13
        customView.backgroundColor = UIColor.redColor()
        imageBack.addSubview(customView)
        
        
        //设置 imageBack 可以用户交互
        imageBack.userInteractionEnabled = true
        
    }
    
    
    func show(targetButton: UIButton) {
        //转换 坐标
        let rect = targetButton.superview!.convertRect(targetButton.frame, toView: nil)
        //设置 imageBack的位置
        self.imageBack?.centerX = targetButton.centerX
        self.imageBack?.y = CGRectGetMaxY(rect)
        
        let window = UIApplication.sharedApplication().windows.last
        window?.addSubview(self)
        
    }
    
    
    @objc private func coverButtonClick(coverButton:UIButton){
        
        //
        if let d = self.delegate {
            d.popViewWillDismiss()
        }
        
        
        //删除imageBack
        removeFromSuperview()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
