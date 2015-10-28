//
//  IWEmotionKeyboard.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/22.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
let CELL_ID = "IWEmotion_cell"
class IWEmotionKeyboard: UIView,IWEmotionToolBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        
        //添加 toolBar
        addSubview(emotionToolBar)
        //添加表情键盘的 collectionView
        addSubview(collectionView)
        //添加 pageControl
        addSubview(pageControl)
    }
    
    
    //添加底部 toolBar
    private lazy var emotionToolBar: IWEmotionToolBar = {
        let toolBar = IWEmotionToolBar()
        toolBar.delegate = self
        return toolBar
    }()
    //设置控件的位置和大小
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置 emotionToolBar 的宽高
        emotionToolBar.width = width
        emotionToolBar.height = 44
        emotionToolBar.y = height - emotionToolBar.height
        //设置 collectionView 的大小和位置
        collectionView.size = CGSizeMake(width, emotionToolBar.y)
        //设置 collectionView 中 cell 的大小
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.size
        
        //设置 pageControl的位置
        pageControl.centerX = width * 0.5
        pageControl.y = emotionToolBar.y - 10
    }
    
    //底部toolBar的代理方法
    func emotionToolBar(toolBar: IWEmotionToolBar, type: IWEmotionToolBarButtonType) {
        //获取点击 toolBar button后的 page所在页
        let pageNum = IWEmotionTools.pageControlFirstNumWithType(type)
        //获取所在页的位置
        let indexPath = NSIndexPath(forRow: pageNum, inSection: 0)
        //滚动
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
    }
    
    // 显示表情的collectionView
    private lazy var collectionView: UICollectionView = {
        //初始化一个 layout
        let layout = UICollectionViewFlowLayout()
        //滑动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        //去掉 cell 的间隙
        layout.minimumLineSpacing = 0
        
        //初始化一个 collectionView
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clearColor()
        //设置分页
        collectionView.pagingEnabled = true
        //设置滚动条
        collectionView.showsHorizontalScrollIndicator = false
        //注册一个系统的collectionViewCel l
        collectionView.registerClass(IWEmotionPageCell.self, forCellWithReuseIdentifier: CELL_ID)
        //设置代理和数据源
        collectionView.delegate = self
        collectionView.dataSource = self
        //
        collectionView.bounces = false
        
        return collectionView
    }()
    
    //pageControl 懒加载
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        //设置颜色
        pageControl.pageIndicatorTintColor = UIColor.blackColor()
        pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()

        return pageControl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IWEmotionKeyboard{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IWEmotionTools.emotionsTotalPageCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //创建 cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CELL_ID, forIndexPath: indexPath) as! IWEmotionPageCell
        
        //获取数据
        let emotions = IWEmotionTools.emotionWithIndexPath(indexPath)
        
        //给 cell 赋值
        cell.indexPath = indexPath
        cell.emotions = emotions
        
        
        return cell
    }
    
    //
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //计算当前滚动到的页码
        let page = round(scrollView.contentOffset.x / scrollView.width)
//        print(page)
        
        //根据当前多少页计算出 当前是哪个类型的表情集合
        let type = IWEmotionTools.emotionTypeWithPageNum(Int(page))
        
        //根据类型 来改变 toolBar  IWEmotionToolBar的选中状态
        emotionToolBar.selectedButtonWithType(type)
        
        if page == 0{
            pageControl.hidden = true
        }else{
            pageControl.hidden = false
            //根据类型计算 pageControl 的页数
            let pageNum = IWEmotionTools.pageControlTotalNumOfPageWithType(type)
            pageControl.numberOfPages = pageNum
            //计算当前pageControl 的当前页
            pageControl.currentPage = IWEmotionTools.pageControlNumOfCurrenPage(Int(page), type: type)
        }
        
        
    }
    
}








