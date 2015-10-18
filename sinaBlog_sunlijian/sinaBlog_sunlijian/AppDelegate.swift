//
//  AppDelegate.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/9.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func hasNewVersion() -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //判断是不是第一次登陆或有新版本
        //取出当前的版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        //取出偏好设置中的版本号
        let appVersion = NSUserDefaults.standardUserDefaults().objectForKey("currentVersion")
        //进行比较
        if appVersion?.compare(currentVersion) == NSComparisonResult.OrderedAscending || appVersion == nil {
            //保存新的版本号
            NSUserDefaults.standardUserDefaults().setValue(currentVersion, forKey: "currentVersion")
            //同步一下
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
    }
    
    //判断账号是否有
    func defaultViewController() -> UIViewController{
        let account = IWUserAccount.loadAccount()
        if (account != nil) {
            return IWWelcomViewController()
        }else{
            return IWNavigationController(rootViewController: IWOAthViewController())
        }
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //初始化一个 WINDOWS
        //判断是不是第一次登陆或有新版本
        let isTrue = hasNewVersion()
        if isTrue {
            window?.rootViewController = IWNewFeatureViewController()
            
        }else {
            window?.rootViewController = defaultViewController()
        }
        //让 windows 可见
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

