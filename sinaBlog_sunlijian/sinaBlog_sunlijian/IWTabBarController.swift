//
//  IWTabBarController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/9.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
private var TABBAR_INDEX_KEY = UnsafePointer<Void>()
class IWTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建 tabBar
        let tabBar = IWTarBar()
        //KVC 给控制器设置 tabBar
        setValue(tabBar, forKeyPath: "tabBar")
        
        //给闭包赋值
        tabBar.plusBtnClick = {
            print("点击了中间加号 button ")
            //初始化一个 view
            let composeView = IWComposeView()
            //进行显示
            composeView.show()
        }
        
        //添加首页
        addChildViewController(HomeTableViewController(), title: "主页", imageName: "tabbar_home", index: 0)
        //添加消息
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center", index: 1)
        //添加发现
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover", index: 2)
        //添加我
        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile", index: 3)
        
        
    }
    //添加控制器
    func addChildViewController(childController: UIViewController, title: String, imageName: String, index: Int) {
        
        
        //设置成我们自己的 tabBarItem
//        let item = IWTabBarItem()
//        item.index = index
//        childController.tabBarItem = item
        let item = IWTabBarItem()
        objc_setAssociatedObject(item, &TABBAR_INDEX_KEY, NSNumber(integer: index), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        //绑定完属性 再赋线控制器
        childController.tabBarItem = item
        
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
        let nav = IWNavigationController(rootViewController: childController)
        //
        addChildViewController(nav)
    }
    
    
    //添加选中时的动画
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //强转成 iwItem
        
        
        //记录一下
        var index = 0
        //遍历 tabBar
        for tabBarChild in tabBar.subviews {
            //取出 tabBarItem
            if tabBarChild.isKindOfClass(NSClassFromString("UITabBarButton")!){
                //判断当前选中 index
                let result = objc_getAssociatedObject(item, &TABBAR_INDEX_KEY)
                
                if index == (result as! Int){
                    //遍历UITabBarButton 找到UITabBarSwappableImageView
                    for tabBarButtonChild in tabBarChild.subviews{
                        //取出UITabBarSwappableImageView
                        if tabBarButtonChild.isKindOfClass(NSClassFromString("UITabBarSwappableImageView")!){
                            //设置UITabBarSwappableImageView的 transform
                            
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                //
                                tabBarButtonChild.transform = CGAffineTransformMakeScale(0.8, 0.8)
                            }, completion: { (finished) -> Void in
                                    //
                                UIView.animateWithDuration(3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                                    //
                                    tabBarButtonChild.transform = CGAffineTransformIdentity
                                }, completion: { (finished) -> Void in
                                    //
                                })
                            })
                        }
                    }
                }
                
                index++
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
