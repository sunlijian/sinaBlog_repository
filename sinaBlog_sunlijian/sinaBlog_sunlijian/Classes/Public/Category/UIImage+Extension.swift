//
//  UIImage+Extension.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/22.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import Foundation

import UIKit

extension UIImage{

    func scale(scaleWidth: CGFloat) -> UIImage{
        
        
        let scaleHeight = scaleWidth / size.width * size.height
        
        let scaleSize = CGSizeMake(scaleWidth, scaleHeight)
        
        
        //开启图形上下文
        UIGraphicsBeginImageContext(scaleSize)
        
        //把当前内容画到指定大小中
        drawInRect(CGRect(origin: CGPointZero, size: scaleSize))
        
        //获取当前图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭图片上下文
        UIGraphicsEndImageContext()
        
        return image
    }
}

