//
//  HomeTableViewController.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/9.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
class HomeTableViewController: UITableViewController,IWPopViewDelegate {
    
    private let CELL_ID = "home_cell_id"
    
    //懒加载
    lazy var statusArray: [IWStatusFrame] = [IWStatusFrame]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置 Home
        setupNav()
        
        //请求数据
        loadData()
        
        //设置 tableView
        setupTableView()
        
        self.tabBarItem.badgeValue = "10"
    }
    
    //设置 tableView
    private func setupTableView(){
        //注册一个 cell
        self.tableView.registerClass(IWStatusCell.self, forCellReuseIdentifier: CELL_ID)
        //上拉加载的控件
        self.tableView.tableFooterView = pullupView
        //下拉刷新的控件
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        //去掉分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //设置 tableView 的背景色
        tableView.backgroundColor = RGB(r: 240, g: 240, b: 240)
    }
    
    
    
    /**
    设置导航栏内容
    */
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.item("navigationbar_friendsearch", title: "", target: self, action: "push")
        navigationItem.rightBarButtonItem = UIBarButtonItem.item("navigationbar_pop", title: "", target: self, action: "push")
        
        setTitleButton()
    }
    
    @objc private func push(){
        
    }
    
    //设置 home navgitionBar 上中间的 title
    private func setTitleButton(){
        //初始化
        let titleButton = IWHomeTitleButton()
        
        //添加点击事件
        titleButton.addTarget(self, action: "titleButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //添加图片
        titleButton.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Selected)
        titleButton.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Normal)
        //添中title
        titleButton.setTitle("首页", forState: UIControlState.Normal)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        //调用IWHomeTitleView 的 sizeToFit
        titleButton.sizeToFit()
        //给当前 Home
        navigationItem.titleView = titleButton
        
    }
    
    
    //中间 titleView 的监听事件
    @objc private func titleButtonClick(button: UIButton) {
        //设置
        button.selected = !button.selected
        //设置弹框
        let contentView = UIView()
        contentView.size = CGSizeMake(150, 150)
        
        //设置 contentView 的位置
        let view = IWPopView(customView: contentView)
        view.delegate = self
        view.show(button)
        
        
    }
    
    
    //代理 方法 改变 button 状态
    func popViewWillDismiss(){
        
        let button = navigationItem.titleView! as! UIButton
        button.selected = false
    }
    
    //请求数据
    @objc private func loadData(){
        //设置接口
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        //设置网络请求管理
//        let manager = AFHTTPSessionManager()
        //开始请求
        //设置请求参数
        var params = ["access_token": IWUserAccount.loadAccount()!.access_token!]
        //改变参数max_id 获取新的数据
        if pullupView.isAnimating(){
            //取当前界面上最后一条数据微博的 id
            if let statusFrame = statusArray.last{
                params["max_id"] = "\(statusFrame.status!.id - 1)"
            }
        }else{
            if let statusFrame = statusArray.first {
                params["since_id"] = "\(statusFrame.status!.id)"
            }
        }
        
        IWNetWorkTools.request(IWNetWorkToolRequestType.GET,url: urlString, paramters: params, success: { (result) -> () in
            //
            let statusArray = result["statuses"] as? [[String : AnyObject]]
            
            //初始化一个数组
            var tempArray = [IWStatusFrame]()
            
            //遍历数组
            for statusDict in statusArray! {
                //初始化模型
                let status = IWStatus(dictionary: statusDict)
                
                //
                let statusFrame = IWStatusFrame()
                statusFrame.status = status
                
                //向临时数组添加
                tempArray.append(statusFrame)
            }
            //添加数据前判断是上拉加载还是下拉刷新
            if self.pullupView.isAnimating(){
                self.statusArray += tempArray
            }else{
                self.statusArray = tempArray + self.statusArray
                //添加刷新时的提示 lable
                if self.statusArray.count != 0{
                    self.showPullDownTips(tempArray.count)
                }
            }
            
            //重新加载数据
            self.tableView.reloadData()
            
            self.endAnimation()
        }) { (error) -> () in
            //
            printLog("错误信息:\(error)")
            SVProgressHUD.showInfoWithStatus("请求失败,你的网络不好")
            
            self.endAnimation()
        }
    }
    
    //结束刷新
    private func endAnimation(){
        self.pullupView.stopAnimating()
        self.refreshControl?.endRefreshing()
    }
    
    //懒加载下拉刷新的 label
    private lazy var pullDownTipLabel: UILabel = {
        let label = UILabel()
        //背景颜色
        label.backgroundColor = UIColor.orangeColor()
        //字体
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = "没有微博数据"
        //大小
//        label.frame = CGRectMake(0, 0, SCREEN_W, 35)
        //添加
        
        self.navigationController?.view.insertSubview(label, belowSubview: (self.navigationController?.navigationBar)!)
        label.hidden = true
        return label
    }()
    
    
    //懒加载上拉刷新的控件
    private lazy var pullupView: UIActivityIndicatorView = {
        let pullupView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        pullupView.color = UIColor.redColor()
        
        return pullupView
    
    }()
    
    
    
    private func showPullDownTips(count: Int){
        //如果是显示状态下
        if pullDownTipLabel.hidden == false {
            return
        }
        
        pullDownTipLabel.text = count == 0 ? "没有微博数据":"\(count)条新微博"
        pullDownTipLabel.hidden = false
        //设置位置
        let height :CGFloat = 35
        pullDownTipLabel.size = CGSizeMake(SCREEN_W, height)
        pullDownTipLabel.y = CGRectGetMaxY(self.navigationController!.navigationBar.frame) - height
        
        //开始动画
        UIView.animateWithDuration(1, animations: { () -> Void in
            //
            self.pullDownTipLabel.transform = CGAffineTransformMakeTranslation(0, height)
        }) { (finished) -> Void in
            //执行回去的代码
            UIView.animateWithDuration(1, delay: 1, options: [], animations: { () -> Void in
                //
                self.pullDownTipLabel.transform = CGAffineTransformIdentity
            }, completion: { (finished) -> Void in
                //执行完毕 隐藏
                self.pullDownTipLabel.hidden = true
            })
        }
    }
}


// MARK: - Table view data source
extension HomeTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID)
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CELL_ID)
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID, forIndexPath: indexPath) as! IWStatusCell
        
        //赋数据
        cell.statusFrame = statusArray[indexPath.row]

        
        //如果当前的 indexPath.row 等于最后一条数据,我们就去加载更多
        
        if indexPath.row == statusArray.count - 1 && !pullupView.isAnimating(){
            //开始加载
            pullupView.startAnimating()
            loadData()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return statusArray[indexPath.row].cellHeight!
    }
    
}


