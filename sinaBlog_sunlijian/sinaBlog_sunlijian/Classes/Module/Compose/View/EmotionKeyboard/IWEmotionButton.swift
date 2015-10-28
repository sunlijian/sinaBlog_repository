//
//  IWEmotionButton.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/24.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWEmotionButton: UIButton {

    var emotion: IWEmotion?{
        didSet{
            //type 为0代表是图片表情
            if emotion!.type == 0 {
                let imageName = "\(emotion!.prePath!)/\(emotion!.png!)"
                setImage(UIImage(named: imageName), forState: UIControlState.Normal)
                setTitle(nil, forState: UIControlState.Normal)
            }else{
                setImage(nil, forState: UIControlState.Normal)
                setTitle((emotion!.code! as NSString).emoji(), forState: UIControlState.Normal)
            }
        }
    }

}
