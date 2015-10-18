//
//  IWWelcomViewController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/13.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
import SDWebImage
class IWWelcomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(headImageView)
        
        view.addSubview(infoLabel)
    }
    private lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        //设置大小
        imageView.size = CGSizeMake(90, 90)
        //设置圆角
        imageView.layer.cornerRadius = imageView.height * 0.5
        imageView.layer.masksToBounds = true
        
        //设置边线
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.orangeColor().CGColor
        
        //加载头像
        
        let url = NSURL(string: IWUserAccount.loadAccount()!.avatar_large!)!
        imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_big"))
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        //文字
        label.text = "欢迎回来"
        //字体颜色 
        label.textColor = UIColor.blackColor()
        //字体大小16
        label.font = UIFont.systemFontOfSize(16)
        //大小
        label.sizeToFit()
        
        label.hidden = true
        
        return label
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //执行动画
        headImageView.centerX = SCREEN_W * 0.5
        headImageView.y = 200
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            //需要执行的动画代码
            self.headImageView.y = 100
        }) { (finish) -> Void in
                //动画执行完毕
            self.infoLabel.centerX = self.headImageView.centerX
            self.infoLabel.y = CGRectGetMaxY(self.headImageView.frame) + 5
            
            //设置初始的透明度
            self.infoLabel.alpha = 0
            //显示 
            self.infoLabel.hidden = false
            
            //执行 label动画
            UIView.animateWithDuration(1, animations: { () -> Void in
                //
                self.infoLabel.alpha = 1
            }, completion: { (finish) -> Void in
                //回到首页
                self.performSelector("toHome", withObject: nil, afterDelay: 1)
            })
            
        }
        
    }
    @objc private func toHome(){
        //获取 delegate
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //取出 window 切换画面
        delegate.window?.rootViewController = IWTabBarController()
    }
    
    

}
