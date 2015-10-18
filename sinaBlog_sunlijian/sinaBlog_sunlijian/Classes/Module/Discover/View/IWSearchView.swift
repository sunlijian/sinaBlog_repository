//
//  IWSearchView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/12.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWSearchView: UIView,UITextFieldDelegate {

    @IBOutlet weak var cons: NSLayoutConstraint!
    
    @IBOutlet weak var textFiled: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func clickCancelButton(sender: UIButton) {
        endEditing(true)
        
        cons.constant = 0
        
        UIView.animateWithDuration(1) { () -> Void in
            self.layoutIfNeeded()
        }
        
    }
    
    //类方法 从 xib 中加载
    class func searchView() -> IWSearchView{
        return NSBundle.mainBundle().loadNibNamed("IWSearchView", owner: nil, options: nil).last as! IWSearchView
    }
    //加载后调用 awakeFromNib 进一步修改
    override func awakeFromNib() {
        
        //设置textField的边框和圆角
        textFiled.layer.borderWidth = 2
        textFiled.layer.borderColor = UIColor.orangeColor().CGColor
        textFiled.layer.cornerRadius = 5
        
        //设置 textField的 leftView
        let leftView = UIImageView(image: UIImage(named: "searchbar_textfield_search_icon"))
        leftView.size = CGSizeMake(height, height)
        leftView.contentMode = UIViewContentMode.Center
        textFiled.leftView = leftView
        textFiled.leftViewMode = UITextFieldViewMode.Always
        
        //设置当前 view 为 textFile 的代理
        textFiled.delegate = self
    }
    
    //代理 方法
    func textFieldDidBeginEditing(textField: UITextField) {
        
        cons.constant = self.cancelButton.width
        
        UIView.animateWithDuration(1) { () -> Void in
            self.layoutIfNeeded()
        }
        
    }
    
    
}
