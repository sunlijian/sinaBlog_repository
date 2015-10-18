//
//  IWNewFeatureViewController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/12.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWNewFeatureViewController: UIViewController, UIScrollViewDelegate {
    
    
    weak var pageControl :UIPageControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化控件
        let scrollView = UIScrollView()
        //设置代理
        scrollView.delegate = self
        //设置 scrollView 的大小
        scrollView.frame = UIScreen.mainScreen().bounds
        scrollView.contentSize = CGSizeMake(SCREEN_W * 4, SCREEN_H)
        
        //添加图片
        let count = 4
        for i in 0..<count {
            let imageName = "new_feature_\(i+1)"
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.size = scrollView.size
            imageView.x = CGFloat(i) * SCREEN_W
            scrollView.addSubview(imageView)
            
            //最后一张图片上添加按钮
            if i == count - 1 {
                
                setupLastPage(imageView)
            }
            
        }
        view.addSubview(scrollView)
        
        //设置 scrollView的属性
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        
        //添加指示器
        let pageControl = UIPageControl()
        //拿手 pageControl
        self.pageControl = pageControl
        
        pageControl.numberOfPages = 4
        pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
        pageControl.pageIndicatorTintColor = UIColor.blackColor()
        pageControl.centerX = scrollView.width * 0.5
        pageControl.y = scrollView.height - 100
        
//        scrollView.addSubview(pageControl)
        view.addSubview(pageControl)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl!.currentPage = Int(page)
    }
    
    private func setupLastPage(imageView:UIImageView){
        let enterBtn = UIButton()
        //设置背景图片
        enterBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        enterBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        //设置title
        enterBtn.setTitle("进入微博", forState: UIControlState.Normal)
        //设置大小 size
        enterBtn.sizeToFit()
        //设置位置
        enterBtn.centerX = SCREEN_W * 0.5
        enterBtn.y = SCREEN_H - 150
        //添加
        imageView.addSubview(enterBtn)
        //设置可以点击
        imageView.userInteractionEnabled = true
        //添加点击事件
        enterBtn.addTarget(self, action: "enterBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        //添加分享的 button
        let sharedBtn = UIButton()
        //设置图片
        sharedBtn.setImage(UIImage(named: "new_feature_share_true"), forState: UIControlState.Normal)
        sharedBtn.setImage(UIImage(named: "new_feature_share_false"), forState: UIControlState.Selected)
        //设置title
        sharedBtn.setTitle("分享到微博", forState: UIControlState.Normal)
        sharedBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        sharedBtn.titleLabel!.font = UIFont.systemFontOfSize(15)
        //设置大小
        sharedBtn.sizeToFit()
        //设置位置
        sharedBtn.centerX = enterBtn.centerX
        sharedBtn.y = enterBtn.y - 35
        //添加
        imageView.addSubview(sharedBtn)
        //添加点击事件
        sharedBtn.addTarget(self, action: "sharedBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    //进入微博的监听事件
    @objc private func enterBtnClick(){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = delegate.window
        window!.rootViewController = delegate.defaultViewController()
    }
    
    
    //分享的监听事件
    @objc private func sharedBtnClick(sender:UIButton){
        sender.selected = !sender.selected
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
