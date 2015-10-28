//
//  IWComposeViewController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/20.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking
//图片整体 view
let COMPOSE_PHOTOS_VIEW_MARGIN: CGFloat = 10


class IWComposeViewController: UIViewController, UITextViewDelegate, IWComposeToolBarDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        //设置导航
        setNav()
        //设置view
        setView()
        
        //添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "emotionButtonDidSelected:", name: IWEmotionButtonDidSelectedNotification, object: nil)
        
        //添加删除字符的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "emotionDeleteButtonClick", name: "IWEmotionDeleteButtonDidSelectedNotification", object: nil)
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
        
    }
    //设置view
    private func setView(){
        //添加 textView
        textView.size = CGSizeMake(SCREEN_W, SCREEN_H)
        //添加的时候 textView 的y 会以 navgationBar 的高度决定 
        view.addSubview(textView)
        //配图控件
        composePhotosView.x = COMPOSE_PHOTOS_VIEW_MARGIN
        composePhotosView.y = 100
        composePhotosView.addButtonClickBlock = {
            //闭包内容
            self.selectPictureButtonClick()
        }
        textView.addSubview(composePhotosView)
        
        //添加底部 toolBar
        toolBar.y = SCREEN_H - toolBar.height
        view.addSubview(toolBar)
        //监听键盘
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    //加载完 textView 的时候弹出键盘
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
    }
    //调整位置
    
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
        button.size = CGSizeMake(44, 30)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        //添加点击事件
        button.addTarget(self, action: "send", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    //textView 的懒加载
    private lazy var textView: IWEmotionTextView = {
        let textView = IWEmotionTextView()
        textView.placeHoldLableText = "label.text = 听说下雪天,吃冰棍特别2B哦"
        textView.font = UIFont.systemFontOfSize(16)
        textView.alwaysBounceVertical = true
        textView.delegate = self
        return textView
        
    }()
    
    //textView的delegate
    func textViewDidChange(textView: UITextView) {
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    //当向下拉拽屏幕的时候
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
    //textView 里的显示图片的懒加载
    private lazy var composePhotosView :IWComposePhotosView = {
        let view = IWComposePhotosView()
        let viewHW = SCREEN_W - 2 * COMPOSE_PHOTOS_VIEW_MARGIN
        view.size = CGSizeMake(viewHW, viewHW)
        return view
    }()
    
    //添加键盘
    private lazy var keyboard: IWEmotionKeyboard = {
        let keyboard = IWEmotionKeyboard()
        keyboard.size = CGSizeMake(SCREEN_W, 258)
        return keyboard
    }()
    
    
    //底部 toolBar 的懒加载
    private lazy var toolBar: IWComposeToolBar = {
        let toolBar = IWComposeToolBar()
        toolBar.size = CGSizeMake(SCREEN_W, 44)
        toolBar.delegate = self
        return toolBar
    }()
    //监听键盘通知
    @objc private func keyboardWillChangeFrame(notify: NSNotification){
        print(notify)
        //取出动画执行的时间
        let duration = (notify.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
        //取出键盘的最终位置
        let rect = (notify.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).CGRectValue()
        //执行动画
        UIView.animateWithDuration(duration) { () -> Void in
            self.toolBar.y = rect.origin.y - self.toolBar.height
        }
    }
    //添加字符
    @objc private func emotionButtonDidSelected(notify: NSNotification){
        //取出 emotion
        let emotion = notify.userInfo!["IWEmotionNotifyKey"] as! IWEmotion
       //设置 emotion 表情到 IWEmotionTextView 上
        textView.insertEmotion(emotion)
    }
    //删除字符
    @objc private func emotionDeleteButtonClick(){
        
        textView.deleteBackward()
    }
    //发送
    @objc private func send(){
        //判断是否有图片
        if composePhotosView.images.count > 0 {
            sendPicStatus(textView.text, image: composePhotosView.images.first!)
        }else{
           //是文字
            sendTextStatus(textView.emotionText)
        }
    }
    //发送文字
    private func sendTextStatus(text: String){
        let url = "https://api.weibo.com/2/statuses/update.json"
        let params = [
            "status": text,
            "access_token": IWUserAccount.loadAccount()!.access_token!
        ]
        IWNetWorkTools.request(.POST, url: url, paramters: params, success: { (result) -> () in
            //
            SVProgressHUD.showSuccessWithStatus("发送成功")
        }) { (error) -> () in
            //
            SVProgressHUD.showErrorWithStatus("发送失败")
        }
    }
    
    //发送带图的微博
    private func sendPicStatus(text: String, image:UIImage){
        let url = "https://upload.api.weibo.com/2/statuses/upload.json"
        let params = [
            "status": text,
            "access_token": IWUserAccount.loadAccount()!.access_token!
        ]

        
        let manager = AFHTTPSessionManager()
        manager.POST(url, parameters: params, constructingBodyWithBlock: { (formData) -> Void in
            let data = UIImageJPEGRepresentation(image, 1)
            formData.appendPartWithFileData(data!, name: "pic", fileName: "hiahia.jepg", mimeType: "image/jpeg")
            
        }, success: { (dataTask, result) -> Void in
            
            SVProgressHUD.showSuccessWithStatus("发送成功")
            
        }) { (dataTask, error) -> Void in
            SVProgressHUD.showErrorWithStatus("发送失败")
        }
    }
    
    //IWComposeToolBar的 delegate方法
    func composeToolBarButtonDidClick(toolBar: IWComposeToolBar, type: ButtonType){
        switch type {
        case .Picture:
            selectPictureButtonClick()
        case .Mention:
            print("@")
        case .Trend:
            print("话题")
        case .Emotion:
            switchKeyboard()
        case .Add:
            print("添加")
        }
    }
    //点击选择图片按钮
    private func selectPictureButtonClick(){
        //创建一个图片选择器
        let imagePicker = UIImagePickerController()
        //指定图片来源
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //设置当前控制器为代理
        imagePicker.delegate = self
        //弹出选择器
        presentViewController(imagePicker, animated: true) { () -> Void in
        }
    }
    //选择键盘
     private func switchKeyboard(){
        
        textView.resignFirstResponder()
        
        
        //设置 textView 的输入 view
        textView.inputView = textView.inputView == nil ? self.keyboard : nil
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            textView.becomeFirstResponder()
        }
        
    }
    
    
    //图片选择器的代理方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        composePhotosView.addImage(image.scale(300))
        
        //选择完图片后 dismiss 控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //删除通知
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
