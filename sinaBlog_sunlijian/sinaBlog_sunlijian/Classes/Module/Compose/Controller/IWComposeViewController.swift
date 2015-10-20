//
//  IWComposeViewController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/20.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWComposeViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        //设置导航
        setNav()
        //设置view
        setView()
    }
    
    
    //设置导航
    private func setNav(){
        //左边 item
        navigationItem.leftBarButtonItem = UIBarButtonItem.item("", title: "取消", target: self, action: "cancel")
        //右边 item
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem?.enabled = false
        //中间的 titleView
        navigationItem.titleView = titleView
        //
        
    }
    
    //设置view
    private func setView(){
        //添加 textView
        textView.size = CGSizeMake(SCREEN_W, SCREEN_H)
        //添加的时候 textView 的y 会以 navgationBar 的高度决定 
        view.addSubview(textView)
        
    }
    
    //左边 item
    @objc private func cancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    //右边 item
    @objc private func sendMessage(){
        
    }
    
    
    //titleView懒加载
    private lazy var titleView: UILabel = {
        let label = UILabel()
        //设置字体
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        //
        if let name = IWUserAccount.loadAccount()?.name {
            label.text = "发微博\n\(name)"
            //初始化一个带有属性的文字
            var attr = NSMutableAttributedString(string: label.text!)
            //名字在 label 上的位置
            let range = (label.text! as NSString).rangeOfString(name)
            //添加属性
            attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range:range)
            attr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: range)
            //
            label.attributedText = attr
            
        }else{
            label.text = "写微博"
        }
        label.sizeToFit()
        return label
    }()
    
    //右边懒加载
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        //设置 button 的文字颜色
        button.setTitle("发送", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        //设置 button 的背景色
        button.setBackgroundImage(UIImage(named: "common_button_orange"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Disabled)
        //
        
        button.size = CGSizeMake(44, 30)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        return button
    }()
    
    private lazy var textView: UITextView = {
        let textView = IWTextView()
        textView.placeHoldLableText = "label.text = 听说下雪天,吃冰棍特别2B哦"
        textView.font = UIFont.systemFontOfSize(16)
        
        textView.delegate = self
        return textView
        
    }()
    
    func textViewDidChangeSelection(textView: UITextView) {
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
