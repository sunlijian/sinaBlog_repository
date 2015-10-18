//
//  IWNetWorkTools.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/18.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
import AFNetworking

enum IWNetWorkToolRequestType: String{
    case GET = "GET"
    case POST = "POST"
}


class IWNetWorkTools: NSObject {
    class func request(type: IWNetWorkToolRequestType,url: String, paramters:[String: AnyObject], success:(result:[String: AnyObject])->(), failure:(error: NSError)->()){
        //请求一个管理对象
        let manager = AFHTTPSessionManager()
        //设置可接受和 contentType
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        //请求成功的闭包
        let successCallBack = {(dataTask: NSURLSessionDataTask, result: AnyObject)->Void in
            if let res = (result as? [String: AnyObject]){
                success(result: res)
            }else{
                failure(error: NSError(domain: "com.itcast.weibo", code: 10001, userInfo: ["errorMsg": "The type of result isn't [String: AnyObject]"]))
            }
        }
        //请求失败的闭包
        let failureCallBack = {(dataTask:NSURLSessionDataTask, error: NSError)->Void in
            failure(error: error)
        }
        
        if type == .GET{
            manager.GET(url, parameters: paramters, success: successCallBack, failure: failureCallBack)
        }else{
            manager.POST(url, parameters: paramters, success: successCallBack, failure: failureCallBack)
        }
    }

}
