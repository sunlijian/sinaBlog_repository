//
//  IWStatusPhotoInfo.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/17.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWStatusPhotoInfo: NSObject {
    
    var thumbnail_pic: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dictionary)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
