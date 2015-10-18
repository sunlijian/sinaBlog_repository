
//
//  IWStatus.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/13.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
//---------------->每一条微博的模型
class IWStatus: NSObject {
    //ID
    var id :Int = 0
    
    
    
    //当前帐号里面的每一条微博的作者
    var user: IWUser?
    //微博的创建时间
    var created_at: String?{
        didSet{//    Sat Oct 17 11:35:32 +0800 2015
            
            //解析创创建时间
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EE MM dd HH:mm:ss z yyyy"
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            let created_date = formatter.dateFromString(created_at!)
            print(created_date)
            //判断是否是同一年
            if(NSDate.isThisYear(created_date!)){
                
                if(NSDate.isToday(created_date!)){
                    //设置今天  
                    let currentDate = NSDate()
                    let timeInterval = currentDate.timeIntervalSinceDate(created_date!)
                    if timeInterval < 60{
                        created_at = "刚刚"
                    }else if timeInterval < 60 * 60{
                        created_at = "\(Int(timeInterval)/60)分钟前"
                    }else{
                        created_at = "\(Int(timeInterval)/(60*60))小时前"
                    }
                    
                    
                }else if(NSDate.isYesterday(created_date!)){
                    //设置昨天
                    formatter.dateFormat = "HH:mm"
                    created_at = "昨天 " + formatter.stringFromDate(created_date!)
                }else{
                    //设置 其他
                    formatter.dateFormat = "MM-dd HH:mm"
                    created_at = formatter.stringFromDate(created_date!)
                }
            //不是同一年
            }else{
                formatter.dateFormat = "yyyy-MM-dd"
                created_at = formatter.stringFromDate(created_date!)
            }
        }
    }
    //微博的来源
    var source: String?{
        didSet{ // "<a href=\"http://weibo.com/\" rel=\"nofollow\">微博 weibo.com</a>"
            let preRange = (source! as NSString).rangeOfString("\">")
            let sufRange = (source! as NSString).rangeOfString("</")
            if preRange.location != NSNotFound{
                if sufRange.location != NSNotFound{
                    let string = (source! as NSString).substringWithRange(NSMakeRange(preRange.location + preRange.length, sufRange.location - preRange.location - preRange.length))
                    source = "来自 \(string)"
                }
            }

        }
    }
    //原创微博内容
    var text: String?
    //原创微博的图片
    var pic_urls: [IWStatusPhotoInfo]?
    //微博的转发数
    var reposts_count: Int = 0
    //微博的评论数
    var comments_count: Int = 0
    //微博的赞
    var attitudes_count: Int = 0
    //转发微博
    var retweeted_status: IWStatus?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dictionary)
    }
    
    
    //当调用  "setValuesForKeysWithDictionary(dictionary)" 会调用 "setValue(value: AnyObject?, forKey key: String)"
    //在这里进行判断 传过来字典 里面是否还把括一个字典
    override func setValue(value: AnyObject?, forKey key: String) {
        if (key as NSString).isEqualToString("user"){
            user = IWUser(dictionary: (value as! [String: AnyObject]))
        }else if (key as NSString).isEqualToString("retweeted_status") {
            retweeted_status = IWStatus(dictionary: (value as! [String: AnyObject]))
        }else if(key as NSString).isEqualToString("pic_urls"){
            //初始化
            pic_urls = [IWStatusPhotoInfo]()
            //遍历数组 得到数组中的字典
            if let v = (value as? [[String: AnyObject]]){
                for tempV in v{
                    let photoInfo = IWStatusPhotoInfo(dictionary: tempV)
                    pic_urls?.append(photoInfo)
                }
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
