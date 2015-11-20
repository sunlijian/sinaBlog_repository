
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
    var text: String?{
        didSet{
            setStatusAttributedText()
        }
    }
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
    
    //当前微博内容带有属性的文字(显示表情)
    var attributedText: NSMutableAttributedString?
    
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
    
    private func setStatusAttributedText(){
        let statusText = text ?? ""
        let attr = NSMutableAttributedString(string: statusText)
        
        //定义一个匹配结果的集合
        var regexResults = [IWMatchResult]()
        
        //匹配当前微博内容里面的表情字符串
        (statusText as NSString).enumerateStringsMatchedByRegex("\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]") { (captureCount, captureString, captureRange, stop) -> Void in
            //
            let result = IWMatchResult()
            result.captureString = captureString.memory! as String
            print(result.captureString)
            result.captureRange = captureRange.memory
            
            regexResults.append(result)
        }
        
        //反转遍历
        for matchResult in regexResults.reverse(){
            
            let emotionChs = matchResult.captureString!

            let emotion = IWEmotionTools.emtionWithChs(emotionChs as String)
            
            if let emo = emotion {
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "\(emo.prePath!)/\(emo.png!)")
                let imageWH = UIFont.systemFontOfSize(CELL_STATUS_TEXT_FONT).lineHeight
                attachment.bounds = CGRectMake(0, -4, imageWH, imageWH)
                
                //生成表情的属性文字
                let emotionAttr = NSAttributedString(attachment: attachment)
                
                attr.replaceCharactersInRange(matchResult.captureRange!, withAttributedString: emotionAttr)
                
            }
            
        }
        //设置字体大小
        attr.addAttribute(NSFontAttributeName, value:  UIFont.systemFontOfSize(CELL_STATUS_TEXT_FONT), range: NSMakeRange(0, attr.length))
        
        //设置高亮
        highlightedLink(attr)
        
        attributedText = attr
    }
    
    //设置高亮链接
    private func highlightedLink(attr: NSMutableAttributedString){
        let string = attr.string as NSString
        //匹配@谁 -->@后面不能跟冒号,也不能跟空格
        string.enumerateStringsMatchedByRegex("@[^:^\\s]+") { (captureCount, captureString, captureRange, stop) -> Void in
            
            //添加文字高亮的属性
            attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: captureRange.memory)
        }
        
        //匹配链接
        string.enumerateStringsMatchedByRegex("http://[^\\s^\\u4e00-\\u9fa5]+") { (captureCount, captureString, captureRange, stop) -> Void in
            
            //添加文字高亮的属性
            attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: captureRange.memory)
        }
        
        //匹配话题
        string.enumerateStringsMatchedByRegex("#[^#]+#") { (captureCount, captureString, captureRange, stop) -> Void in
            
            //添加文字高亮的属性
            attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: captureRange.memory)
        }
    }
    
    

}
