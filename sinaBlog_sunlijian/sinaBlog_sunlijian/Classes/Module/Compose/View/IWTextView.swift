//
//  IWTextView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/20.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
let TEXT_CONTAINER_MAGIN: CGFloat = 5
class IWTextView: UITextView {
    
    //添加两个属性 占位内容 和 占位内容字体的大小
    var placeHoldLableText: String?{
        didSet{
            placeHoldLable.text = placeHoldLableText ?? ""
        }
    }
    override var font:UIFont?{
        didSet{
            placeHoldLable.font = font
        }
    }
    

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        //添加一个 label 作为占位用
        addSubview(placeHoldLable)
        
        //添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidChange:", name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    
    //占位 label 的懒加载
    private lazy var placeHoldLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.lightGrayColor()
        label.text = "听说下雪天,吃冰棍特别2B哦"
        return label
    }()
    
    //设置占位 label 的位置
    override func layoutSubviews() {
        super.layoutSubviews()
        placeHoldLable.x = TEXT_CONTAINER_MAGIN
        placeHoldLable.y = 8
        placeHoldLable.size = (placeHoldLable.text ?? "").size(placeHoldLable.font, constrainedToSize: CGSizeMake(SCREEN_W - 2*TEXT_CONTAINER_MAGIN, CGFloat(MAXFLOAT)))
    }

    //通知
    func textViewDidChange(notify: NSNotification){
        placeHoldLable.hidden = self.hasText()
    }
    //移除通知
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
