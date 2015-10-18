//
//  String+Extension.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/16.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import Foundation
import UIKit

extension String{
    //定一个分类的 对象方法
    func size(font: UIFont, constrainedToSize: CGSize = CGSizeZero) -> CGSize{
        let string = self as NSString
        
        let attrs = [NSFontAttributeName: font]
        
        return string.boundingRectWithSize(constrainedToSize, options: [NSStringDrawingOptions.UsesLineFragmentOrigin], attributes: attrs, context: nil).size
    }
}