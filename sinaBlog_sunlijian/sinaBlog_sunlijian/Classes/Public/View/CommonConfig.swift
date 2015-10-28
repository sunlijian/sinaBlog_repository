//
//  CommonConfig.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/10.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import Foundation
import UIKit

let IWEmotionButtonDidSelectedNotification = "IWEmotionButtonDidSelectedNotification"
/// 删除按钮点击的通知
let IWEmotionDeleteButtonDidSelectedNotification = "IWEmotionDeleteButtonDidSelectedNotification"
let SCREEN_W = UIScreen.mainScreen().bounds.size.width
let SCREEN_H = UIScreen.mainScreen().bounds.size.height

func printLog(message: AnyObject, error: Bool = false, fileName: String = __FILE__, line: Int = __LINE__, method: String = __FUNCTION__){
    
    if error {
        print("\((fileName as NSString).lastPathComponent)[\(line)], \(method):\(message)")
    }else {
        #if DEBUG
            print("\((fileName as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
    
}
func RGB(r r: CGFloat,g: CGFloat, b: CGFloat) -> UIColor {
    
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
}

func RandomColor() -> UIColor {
    
    return RGB(r: CGFloat(random() % 255), g: CGFloat(random() % 255), b: CGFloat(random() % 255))
    
}