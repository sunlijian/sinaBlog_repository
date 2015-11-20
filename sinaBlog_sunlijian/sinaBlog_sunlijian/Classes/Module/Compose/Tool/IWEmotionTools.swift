//
//  IWEmotionTools.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/23.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit



class IWEmotionTools: NSObject {
    
    //默认表情集合
    static let defaultEmotions: [IWEmotion] = {
        return IWEmotionTools.loadEmotions("EmotionIcons/default/info.plist")
    }()
    //emoji表情集合
    static let emojiEmotions: [IWEmotion] = {
        return IWEmotionTools.loadEmotions("EmotionIcons/emoji/info.plist")
    }()
    //浪小花表情集合
    static let LxhEmotions: [IWEmotion] = {
        return IWEmotionTools.loadEmotions("EmotionIcons/lxh/info.plist")
        }()
    //最近表情集合
    static var recentEmotions:[IWEmotion] = {
        //解档
        let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("recentEmotion.archive")
        var result = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        
        print(result)
        if result == nil {
            return [IWEmotion]()
        }else{
            return result as! [IWEmotion]
        }
    }()
    
    
    //加载表情
    private class func loadEmotions(path: String) -> [IWEmotion]{
        //路径
        let bundlePath = NSBundle.mainBundle().pathForResource(path, ofType: nil)
        //数组
        let array = NSArray(contentsOfFile: bundlePath!)
        //临时数组
        var tempArray = [IWEmotion]()
        //遍历数组
        for value in array!{
            let emotion = IWEmotion(dictionary: (value as! [String: AnyObject]))
            emotion.prePath = (path as NSString).stringByDeletingLastPathComponent
            //添加到数组中
            tempArray.append(emotion)
        }
        return tempArray
    }
    
    //一共多少页
    class func emotionsTotalPageCount() -> Int{
//        let defaultEmotionPage = (defaultEmotions.count - 1) / 20 + 1
//        let emojiEmotionPage = (emojiEmotions.count - 1) / 20 + 1
//        let lxhEmotionPage = (LxhEmotions.count - 1) / 20 + 1
//        let recentEmotionPage = 1
        let defaultEmotionPage = defaultEmotionRange.length
        let emojiEmotionPage = emojiEmotionRange.length
        let lxhEmotionPage = LxhEmotionRange.length
        let recentEmotionPage = recentEmotionRange.length
        
        return defaultEmotionPage + emojiEmotionPage + lxhEmotionPage + recentEmotionPage
    }
    
    //默认表情集合范围
    
    static let recentEmotionRange: NSRange = {
        return NSMakeRange(0, 1)
    }()
    
    static let defaultEmotionRange: NSRange = {
        return NSMakeRange(1, 5)
    }()
    //Emoji 表情集合范围
    static let emojiEmotionRange: NSRange = {
        return NSMakeRange(6, 4)
    }()
    //路小花 表情集合范围
    static let LxhEmotionRange: NSRange = {
        return NSMakeRange(10, 2)
    }()
    
    //根据当前页 计算是属于哪个类弄的表情集合
    class func emotionTypeWithPageNum(pageNum: Int) -> IWEmotionToolBarButtonType {
        if pageNum == 0{
            return .Recent
        }else if (NSLocationInRange(pageNum, defaultEmotionRange)){
            return .Default
        }else if (NSLocationInRange(pageNum, emojiEmotionRange)){
            return .Emoji
        }else{
            return .Lxh
        }
    }
  
    //根据类型 计算出 pageControl 的页数
    class func pageControlTotalNumOfPageWithType(type: IWEmotionToolBarButtonType) -> Int{
        switch type{
        case .Recent: return 1
        case .Default: return defaultEmotionRange.length
        case .Emoji: return emojiEmotionRange.length
        case .Lxh: return LxhEmotionRange.length
        }
    }
    //根据类型和当前的页 算出 currentPage
    class func pageControlNumOfCurrenPage(page: Int, type: IWEmotionToolBarButtonType) -> Int{
        switch type{
        case .Recent: return 0
        case .Default: return page - recentEmotionRange.length
        case .Emoji: return page - recentEmotionRange.length - defaultEmotionRange.length
        case .Lxh: return page - recentEmotionRange.length - defaultEmotionRange.length - emojiEmotionRange.length
        }
    }
    //点击 toolBar 里的 Button的时候 根据类型 获取当前类型的集合的范围 返回 range 的 loaction
    class func pageControlFirstNumWithType(type: IWEmotionToolBarButtonType) -> Int{
        switch type{
        case .Recent: return recentEmotionRange.location
        case .Default: return defaultEmotionRange.location
        case .Emoji: return emojiEmotionRange.location
        case .Lxh: return LxhEmotionRange.location
        }
    }
    //根据indexPath 获取当前页的数据
    class func emotionWithIndexPath(indexpath: NSIndexPath) -> [IWEmotion]{
        //当前是第几页
        let page = indexpath.row
        //当前所属的表情类型
        let type = IWEmotionTools.emotionTypeWithPageNum(page)
        //当前页
        let currentPage = IWEmotionTools.pageControlNumOfCurrenPage(page, type: type)
        //获取类型的集合
        func emotionsArrayWithType(type: IWEmotionToolBarButtonType) -> [IWEmotion]{
            switch type{
            case .Recent: return recentEmotions
            case .Default: return defaultEmotions
            case .Emoji: return emojiEmotions
            case .Lxh: return LxhEmotions
            }
        }
        
        
        let emotionArray = emotionsArrayWithType(type)
        print(emotionArray.count)
        
        //从类型集合中截取当前页的数据
        let location = currentPage * PAGE_EMOTION_MAX
        var length = PAGE_EMOTION_MAX
        if (location + length) > emotionArray.count {
            length = emotionArray.count - location
        }
        let emotions = (emotionArray as NSArray).subarrayWithRange(NSMakeRange(location, length))
        
        return emotions as! [IWEmotion]
    }
    //保存最近使用表情
    class func saveEmotion(emotion: IWEmotion){
        //保存路径
        let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("recentEmotion.archive")
        //在保存到集合中进行判断
        let result = recentEmotions.contains(emotion)
        if result {
            let index = (recentEmotions as NSArray).indexOfObject(emotion)
            recentEmotions.removeAtIndex(index)
        }
        
        
        //保存到集合中
        recentEmotions.insert(emotion, atIndex: 0)
        //归档
        NSKeyedArchiver.archiveRootObject(recentEmotions, toFile: path)
    }
    
    
    //通过表情描述 找到对应的表情模型
    class func emtionWithChs(chs: String) -> IWEmotion?{
        //遍历默认表情
        for emotion in defaultEmotions{
            if (emotion.chs! as NSString).isEqual(chs){
                return emotion
            }
        }
        
        //遍历浪小花
        for emotion in LxhEmotions{
            if (emotion.chs! as NSString).isEqual(chs){
                return emotion
            }
        }
        
        return nil
    }
    
    
}
