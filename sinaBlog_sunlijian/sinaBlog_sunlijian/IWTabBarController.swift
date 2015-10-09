//
//  IWTabBarController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/9.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加控制器
        addChildViewController(HomeTableViewController(), title: "主页", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
        
        
    }
    //添加控制器
    func addChildViewController(childController: UIViewController, title: String, imageName: String) {
        //设置标题
        childController.title = title
        //设置图片
        childController.tabBarItem.image = UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //设置选中时的图片
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //设置选中下字体颜色   字体大小需要 Normal状态下设置
        let attibutes = [NSForegroundColorAttributeName : UIColor.orangeColor()]
        childController.tabBarItem.setTitleTextAttributes(attibutes, forState: UIControlState.Selected)
        
        //设置导航控制器
        let nav = UINavigationController(rootViewController: childController)
        //
        addChildViewController(nav)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
