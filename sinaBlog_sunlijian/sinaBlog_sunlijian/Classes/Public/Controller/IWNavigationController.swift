//
//  IWNavigationController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/9.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            
            var titleName = "返回"
            
            if childViewControllers.count == 1 {
                titleName = childViewControllers.first!.title!
            }
            viewController.hidesBottomBarWhenPushed = true
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.item("navigationbar_back_withtext", title: titleName, target: self, action: "back")
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func back() {
        popViewControllerAnimated(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
