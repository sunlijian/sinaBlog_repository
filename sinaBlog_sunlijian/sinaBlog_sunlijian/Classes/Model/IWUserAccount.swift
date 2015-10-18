//
//  IWUserAccount.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/13.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWUserAccount: NSObject,NSCoding {
    
    //访问令牌
    var access_token: String?
    //过期时间
    var expires_in: NSTimeInterval = 0{//  如果是 Int?系统不会分配空间 会默认抛出一个错误 undefinedKey  Int = 0会分配空间
        didSet{
            let nowDate = NSDate()
            expires_date = nowDate.dateByAddingTimeInterval(expires_in)
        }
    }
    var remind_in :String?
    
    //用户的 uid
    var uid: String?
    //过期的时间
    var expires_date :NSDate?
    //用户的高清头像
    var avatar_large: String?
    //用户名
    var name : String?
    
    init(dictionary:[String: AnyObject]) {
        super.init()
        //字典转模型
        setValuesForKeysWithDictionary(dictionary) //基于运行时的 运行的时候自动分配内存空间
    }
    
    //内部默认实现 如果只想要转一部分key  必须重写这个方法 从而忽略不需要转的值
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    //重写 description 打印出的是  字典类型的样式
    override var description: String {
        let keys = ["access_token","expires_in","remind_in","uid"]
        
        return dictionaryWithValuesForKeys(keys).description
    }
    
    //拿到路径
    static let path = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.archiver")
    //保存帐号信息 进行归档
    func saveAccount(){
        print(IWUserAccount.path)
        //归档
        NSKeyedArchiver.archiveRootObject(self, toFile: IWUserAccount.path)
    }
    
    class func loadAccount() -> IWUserAccount?{
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(self.path) as? IWUserAccount
        
        if let acc = account {
            
            if acc.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                return account
            }
        }
        return nil
    }
    
    
    
    
    //怎么归档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(remind_in, forKey: "remind_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(name, forKey: "name")
    }
    //怎么解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        remind_in = aDecoder.decodeObjectForKey("remind_in") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
    }
}
