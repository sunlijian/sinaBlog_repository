//
//  IWUser.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/15.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
//--------------------->每一条微博模型里的user这个key对应的一个字典 对应的模型
class IWUser: NSObject {
    //用户头像
    var profile_image_url: String?
    //用户姓名
    var name: String?
    //会员类型  如果大于2 就代表是会员
    var mbtype: Int = 0{
        didSet{
            isVip = (mbtype > 2)
        }
    }
    //会员等级
    var mbrank: Int = 0
    //是否是会员
    var isVip: Bool = false
    //字典转模型
    init(dictionary: [String: AnyObject]) {
        super.init()
        //KVC
        setValuesForKeysWithDictionary(dictionary)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        //
    }
}
