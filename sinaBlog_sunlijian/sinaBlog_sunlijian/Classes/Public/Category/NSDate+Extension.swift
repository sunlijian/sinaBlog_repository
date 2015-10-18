//
//  NSDate+Extension.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/18.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import Foundation
import UIKit
extension NSDate{
    //判断是否是今年
    class func isThisYear(date: NSDate) -> Bool{
        //时间格式化器
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        //当前时间
        let currentDate = NSDate()
        //转化为字符串
        let dateStr = formatter.stringFromDate(date)
        let currentDateStr = formatter.stringFromDate(currentDate)
        //        print(dateStr)
        //进行比较 看是否是今年
        return (dateStr as NSString).isEqualToString(currentDateStr)
    }
    //判断是否是同一天
    class func isToday(date: NSDate) -> Bool{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = NSDate()
        //转成字符串 判断是否相等
        let dateStr = formatter.stringFromDate(date)
        let currentDateStr = formatter.stringFromDate(currentDate)
        return (dateStr as NSString).isEqualToString(currentDateStr)
        
    }
    //判断是否是昨天
    class func isYesterday(var date: NSDate) -> Bool{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var currentDate = NSDate()
        //转化成一定格式的字符串 (去掉时 和 分) 再转成日期进行比较
        let dateStr = formatter.stringFromDate(date)
        let currentDateStr = formatter.stringFromDate(currentDate)
        date = formatter.dateFromString(dateStr)!
        currentDate = formatter.dateFromString(currentDateStr)!
        //比较
        let result = currentDate.timeIntervalSinceDate(date)
        if result == 24 * 60 * 60{
            return true
        }
        return false
    }
    //判断是否是昨天 第二种方法
    class func isYesterday2(var date:NSDate) -> Bool{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var currentDate = NSDate()
        //转化成 string 再转化成 date 去掉 date与currentDate 的小时和分钟
        let dateStr = formatter.stringFromDate(date)
        let currentDateStr = formatter.stringFromDate(currentDate)
        date = formatter.dateFromString(dateStr)!
        currentDate = formatter.dateFromString(currentDateStr)!
        
        //创建 日期
        let calendar = NSCalendar.currentCalendar()
        //[NSCalendarUnit.NSDayCalendarUnit] 在 Ios8可以使用
        let components = calendar.components([NSCalendarUnit.NSDayCalendarUnit], fromDate: date, toDate: currentDate, options: NSCalendarOptions.WrapComponents)
        if components.day == 1{
            return true
        }
        return false
    }
}