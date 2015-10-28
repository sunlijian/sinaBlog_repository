//
//  IWEomotionPopView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/24.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWEmotionPopView: UIView {

    class func popView() -> IWEmotionPopView{
        
        return NSBundle.mainBundle().loadNibNamed("IWEmotionPopView", owner: nil, options: nil).last! as! IWEmotionPopView
    }

    @IBOutlet weak var emotionButton: IWEmotionButton!
}
