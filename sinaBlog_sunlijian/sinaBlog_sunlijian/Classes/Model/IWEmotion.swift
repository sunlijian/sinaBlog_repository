//
//  IWEmotion.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/23.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWEmotion: NSObject , NSCoding{
        
    /// 当前表情的文字描述
    var chs: String?
    /// 繁体描述
    var cht: String?
    /// 当前表情的图片名
    var png: String?
    /// 当前表情的类型 如果为0代表是图片表情 如果为1代表是emoji表情
    var type: Int = 0
    /// emoji表情的code
    var code: String?
    ///
    var prePath: String?

    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dictionary)
    }
    
    //归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(chs, forKey: "chs")
        aCoder.encodeObject(cht, forKey: "cht")
        aCoder.encodeObject(png, forKey: "png")
        aCoder.encodeObject(code, forKey: "code")
        aCoder.encodeObject(prePath, forKey: "prePath")
        aCoder.encodeInteger(type, forKey: "type")
    }
    //解档
    required init?(coder aDecoder: NSCoder) {
        chs = aDecoder.decodeObjectForKey("chs") as? String
        cht = aDecoder.decodeObjectForKey("cht") as? String
        png = aDecoder.decodeObjectForKey("png") as? String
        code = aDecoder.decodeObjectForKey("code") as? String
        prePath = aDecoder.decodeObjectForKey("prePath") as? String
        type = aDecoder.decodeIntegerForKey("type")
    }
    
    //let result = recentEmotions.contains(emotion) 当执行这行代码时 会调用
    override func isEqual(object: AnyObject?) -> Bool {
        let emotion = object! as! IWEmotion
        if emotion.type == type {
            if type == 0{
                if (chs! as NSString).isEqualToString(emotion.chs!) {
                    return true
                }
            }else{
                if (code! as NSString).isEqualToString(emotion.code!){
                    return true
                }
            }
        }
        return false
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}

}
