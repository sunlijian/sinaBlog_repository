
//
//  IWComposePhotoView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/22.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWComposePhotoView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
        //添加按钮
        addSubview(deleteButton)
        //设置可以用户交互
        userInteractionEnabled = true
    }
    
    
    //懒加载
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        //设置图片
        button.setImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        //设置大小
        button.sizeToFit()
        //添加点击事件
        button.addTarget(self, action: "deleteButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    //button 的点击事件
    @objc private func deleteButtonClick(){
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
    //设置按钮的位置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        deleteButton.x = width - deleteButton.width
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
