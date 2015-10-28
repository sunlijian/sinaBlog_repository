//
//  IWEmotionTextView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/27.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWEmotionTextView: IWTextView {
    
    
    
    //计算型属性
    var emotionText: String{
        var statusText = String()
        //遍历
        attributedText.enumerateAttributesInRange(NSMakeRange(0, attributedText.length), options: []) { (dict, range, stop) -> Void in
            //如果发现是NSTextAttachment,就代表是表情
            if let attachment = dict["NSAttachment"] {
                print(attachment)
                statusText += (attachment as! IWEmotionTextAttachment).emotion!.chs!
            }else{
                //是文字
                statusText += (self.attributedText.string as NSString).substringWithRange(range)
            }
            print(dict)
            print(range)
        }
        return statusText
    }
    

    func insertEmotion(emotion: IWEmotion){
        //判断 emotion 的 type
        if emotion.type == 1 {//emoji表情
            insertText((emotion.code! as NSString).emoji())
            //            textView.replaceRange(textView.selectedTextRange!, withText: (emotion.code! as NSString).emoji())
        }else{//不是 emoji 表情
            //处理表情
            //初始化一个文字附件
            let attachment = IWEmotionTextAttachment()
            //添加一个 emotion 属性
            attachment.emotion = emotion
            attachment.image = UIImage(named: "\(emotion.prePath!)/\(emotion.png!)")
            attachment.bounds = CGRectMake(0, -4, font!.lineHeight, font!.lineHeight)
            //通过文字附件初始化一个NSAttributeString
            let attributeString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            //添加一个NSFontAttributeName 属性
            attributeString.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, 1))
            
            
            //取出textView 已经存在的 attributeText
            let original = NSMutableAttributedString(attributedString: attributedText)
            //获取当前选中的 range
            let range = selectedRange
            
            //添加处理过后的 表情
            original.replaceCharactersInRange(selectedRange, withAttributedString: attributeString)
            //然后再把添加后的 original设置成textView 的attributeText
            attributedText = original
            //重新设置光标的位置
            selectedRange = NSMakeRange(range.location + 1, 0)
            
            //添加一个通知
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self, userInfo: nil)
            
            //执行代理 
            if let dele = delegate {
                dele.textViewDidChange!(self)
            }
            
        }
    }

}
