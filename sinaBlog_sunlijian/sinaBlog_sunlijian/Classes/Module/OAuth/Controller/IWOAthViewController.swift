//
//  IWOAthViewController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/13.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
import AFNetworking
//App Key：2039429805
//App Secret：27b45a9dc97a16956a49f95b991a5f1a

//请求
//https://api.weibo.com/oauth2/authorize?client_id=123050457758183&redirect_uri=http://www.example.com/response&response_type=code

//同意授权后会重定向
//http://www.example.com/response&code=CODE

class IWOAthViewController: UIViewController, UIWebViewDelegate {
    //拼接请求网址
    let client_id = "2039429805"
    let client_secret = "27b45a9dc97a16956a49f95b991a5f1a"
    let redirect_uri = "http://www.qq.com"
    
    weak var webView: UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加自动添充按钮
        setupNav()
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        //创建 webView
        let webView = UIWebView(frame: CGRectMake(0, 0, SCREEN_W, SCREEN_H))
        //加载 request
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        //添加到当前 VIEW 上
        view.addSubview(webView)
        //设置代理
        webView.delegate = self
        
        self.webView = webView
    }
    
    private func setupNav(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: UIBarButtonItemStyle.Plain, target: self, action: "autoinput")
    }
    @objc private func autoinput(){
        
        let script = "document.getElementById('userId').value='366799188@qq.com';document.getElementById('passwd').value='2431009'"
        
        self.webView!.stringByEvaluatingJavaScriptFromString(script)
    }
    
    
    
    //加载 webView 时的代理 方法
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //获取加载的网址
        let urlString = request.URL!.absoluteString
        //获取点击授权后调用的网址
        if urlString.hasPrefix(redirect_uri) {
            
            //获取 code
            let codePre = "code="
            let rang = (urlString as NSString).rangeOfString(codePre)
            if rang.location != NSNotFound {
                let code = (urlString as NSString).substringFromIndex(rang.location + rang.length)
                
                print(code)//8b0e14d6b02dab43ef31e7bead160fec
                
                loadAccessToken(code)
                
                return false
            }
        }
        return true
    }
    
    //获取授权过的 accessToken
    private func loadAccessToken(code: String){
        //请求地址
        let urlString = "https://api.weibo.com/oauth2/access_token"
        //请求参数
        let paramters = [
            "client_id": client_id,
            "client_secret" : client_secret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirect_uri
        ]
        //请求管理者
        let manager = AFHTTPSessionManager()
        //添加请求类型
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        //开始请求
        manager.POST(urlString, parameters: paramters, success:
        { (dataTask, result) -> Void in
            //请请成功的闭包
            print("请求成功:\(result)")
            
            let account = IWUserAccount(dictionary: (result as? [String : AnyObject])!)
            
            print(account)
            //获取成功后 保存帐号信息 归档
//            account.saveAccount()
            self.loadUserInfo(account)
            

            
            
        }) { (dataTask, error) -> Void in
                //请求失败的闭包
            print("请求失败:\(error)")
        }
        
    }
    
    private func loadUserInfo(account: IWUserAccount) {
        let manager = AFHTTPSessionManager()
        
        //请求地址
        let urlString = "https://api.weibo.com/2/users/show.json"
        //拼装参数
        let prams = [
            "access_token":account.access_token!,
            "uid": account.uid!
        ]
        //发送 get请求
        manager.GET(urlString, parameters: prams, success: { (dataTask, result) -> Void in
            //通过 accessToken 获取个人信息成功
            if let res = (result as? [String: AnyObject]) {
                //获取头象
                account.avatar_large = res["avatar_large"] as? String
                //获取昵称
                account.name = res["name"] as? String
                
                //保存
                account.saveAccount()
                
                //跳转控制器到欢迎页
                let window = UIApplication.sharedApplication().delegate!.window!
                window?.rootViewController = IWWelcomViewController()
            }
        }) { (dataTask, error) -> Void in
            //
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
