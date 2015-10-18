//
//  IWStatusPhotos.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/17.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

//图片最大的张数
private let PHOTO_MAX_COUNT = 9
//图片的间距
private let PHOTO_MAGIN:CGFloat = 10
class IWStatusPhotos: UIView {
    
    //设置数据
    var pic_urls: [IWStatusPhotoInfo]?{
        didSet{
            setPicUrls()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加9张图片
        for _ in 0..<PHOTO_MAX_COUNT{
            let imageView = IWStatusPhotoImageView(frame:CGRectZero)
//            //设置图片的显示模式
//            imageView.contentMode = UIViewContentMode.ScaleAspectFill
//            //去掉超出部分
//            imageView.clipsToBounds = true
            
            
            
            addSubview(imageView)
        }
    }
    //设置子控件的位置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //如果没有 pic_urls 返回
        if pic_urls == nil {
            return
        }
        
        //一共多少列
        let columMax = 3
        //每一个子控件的宽度
        let childViewHW = (SCREEN_W - 4 * PHOTO_MAGIN) / CGFloat(columMax)
        //如果只有4张的图片的时候
        let colum = pic_urls?.count == 4 ? 2 : columMax
        
        //遍历
        for i in 0..<pic_urls!.count {
            let childView = subviews[i]
            //行  列 的索引
            let rowIndex = i / colum
            let colIndex = i % colum
            //子控件的 x y size 
            let childViewX = (PHOTO_MAGIN + childViewHW) * CGFloat(colIndex)
            let childViewY = (PHOTO_MAGIN + childViewHW) * CGFloat(rowIndex)
            //frame
            childView.frame = CGRect(origin: CGPointMake(childViewX, childViewY), size: CGSizeMake(childViewHW, childViewHW))
        }
        
    }
    //赋值
    private func setPicUrls(){
        //先全部隐藏
        for childView in subviews{
            childView.hidden = true
        }
        //遍历
        for i in 0..<pic_urls!.count{
            let childView = subviews[i] as! IWStatusPhotoImageView
            childView.hidden = false
            let info = pic_urls![i]
//            childView.sd_setImageWithURL(NSURL(string: info.thumbnail_pic!), placeholderImage: UIImage(named: "timeline_image_placeholder"))
            childView.thumbnail_pic = info.thumbnail_pic!
        }
    }
    //根据图片的大小 设置当前 view 的大小
    class func size(count: Int) -> CGSize{
        //根据有多少行 计算出高度
        let columMax = 3
        let row = (count - 1) / columMax + 1
        //计算每个子控件的高度
        let childViewHW = (SCREEN_W - 4 * PHOTO_MAGIN) / CGFloat(columMax)
        //计算size
        let viewH = CGFloat(row) * childViewHW + CGFloat(row - 1) * PHOTO_MAGIN
        let viewW = SCREEN_W - 2 * PHOTO_MAGIN
        return CGSizeMake(viewW, viewH)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
