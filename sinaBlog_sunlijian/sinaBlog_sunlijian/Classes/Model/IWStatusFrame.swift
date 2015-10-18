//
//  IWStatusFrame.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/15.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
//定义 cell里字控件的间距
private let CELL_CHILD_VIEW_MARGIN :CGFloat = 10

//定义名字字体的大小
let CELL_STATUS_NAME_FONT: CGFloat = 14

//定义创建时间的字体大小
let CELL_STATUS_CREATE_AT_FONT: CGFloat = 10

//微博内容字体的大小
let CELL_STATUS_TEXT_FONT: CGFloat = 15

class IWStatusFrame: NSObject {
    var status: IWStatus? {
        didSet{
            setStatus()
        }
    }
    //整体 原创 view 的 frame
    var originalViewF:CGRect?
    //头像
    var headImageViewF:CGRect?
    //姓名
    var nameLableF: CGRect?
    //vip
    var vipImageViewF: CGRect?
    //创建时间
    var created_atF: CGRect?
    //来源
    var sourceF: CGRect?
    //原创微博内容
    var textF: CGRect?
    //原创微博的图片
    var originalPhotosF: CGRect?
    //转发微博的整体 view
    var retweetViewF:CGRect?
    //转发微博 内容
    var retweetTextLabelF: CGRect?
    //转发微博的图片
    var retweetPhotosF: CGRect?
    //计算底部 toolBar的frame
    var statusToolBarF:CGRect?
    //cell的高度
    var cellHeight: CGFloat?
    //计算 frame
    private func setStatus(){
        let status = self.status!
        
//----------------------------------------计算原创微博的frame-----------------------------------------------------//
        //原创整体 view 的 frame
        let originalViewX :CGFloat = 0
        let originalViewY = CELL_CHILD_VIEW_MARGIN
        let originalViewW = SCREEN_W
        var originalViewH :CGFloat = 0
        //头像
        let headImageViewX = CELL_CHILD_VIEW_MARGIN
        let headImageViewY = CELL_CHILD_VIEW_MARGIN
        let headImageSize = CGSizeMake(35, 35)
        headImageViewF = CGRect(origin: CGPointMake(headImageViewX, headImageViewY), size: headImageSize)
        //姓名
        let nameLabelX = CGRectGetMaxX(headImageViewF!) + CELL_CHILD_VIEW_MARGIN
        let nameLabelY = CELL_CHILD_VIEW_MARGIN
        let nameLabelSize = status.user!.name!.size(UIFont.systemFontOfSize(CELL_STATUS_NAME_FONT))
        nameLableF = CGRect(origin: CGPointMake(nameLabelX, nameLabelY), size: nameLabelSize)
        //会员
        //frame
        let vipImageViewX = CGRectGetMaxX(nameLableF!) + CELL_CHILD_VIEW_MARGIN
        let vipImageViewY = headImageViewY
        let vipImageVeiwSize = CGSizeMake(nameLabelSize.height, nameLabelSize.height)
        vipImageViewF = CGRect(origin: CGPointMake(vipImageViewX, vipImageViewY), size: vipImageVeiwSize)
        //创建时间
        let created_atX = nameLabelX
        let created_atSize = status.created_at!.size(UIFont.systemFontOfSize(CELL_STATUS_CREATE_AT_FONT))
        let created_atY = CGRectGetMaxY(headImageViewF!) - created_atSize.height
        created_atF = CGRect(origin: CGPointMake(created_atX, created_atY), size: created_atSize)
        //微博来源
        let sourceX = CGRectGetMaxX(created_atF!) + CELL_CHILD_VIEW_MARGIN
        let sourceY = created_atY
        let sourceSize = status.source?.size(UIFont.systemFontOfSize(CELL_STATUS_CREATE_AT_FONT))
        sourceF = CGRect(origin: CGPointMake(sourceX, sourceY), size: sourceSize!)
        //原创微博内容
        let textX = CELL_CHILD_VIEW_MARGIN
        let textY = CGRectGetMaxY(headImageViewF!) + CELL_CHILD_VIEW_MARGIN
        let textSize = status.text?.size(UIFont.systemFontOfSize(CELL_STATUS_TEXT_FONT), constrainedToSize: CGSizeMake(SCREEN_W - 2 * CELL_CHILD_VIEW_MARGIN, CGFloat(MAXFLOAT)))
        textF = CGRect(origin: CGPointMake(textX, textY), size: textSize!)
        
        //原创微博整体 view 的 H
        originalViewH = CGRectGetMaxY(textF!)
        //原创微博的图片
        if let originalPhotosUrls = status.pic_urls where status.pic_urls?.count > 0{
            let originalPhotosX = CELL_CHILD_VIEW_MARGIN
            let originalPhotosY = CGRectGetMaxY(textF!) + CELL_CHILD_VIEW_MARGIN
            let originalPhotosSize = IWStatusPhotos.size(originalPhotosUrls.count)
            originalPhotosF = CGRect(origin: CGPointMake(originalPhotosX, originalPhotosY), size: originalPhotosSize)
            //整体 view 的 y
            originalViewH = CGRectGetMaxY(originalPhotosF!)
        }
        //整体的 view.frame
        originalViewF = CGRectMake(originalViewX, originalViewY, originalViewW, originalViewH)
        
        //底部toolBar 的Y
        var statusToolBarY = CGRectGetMaxY(originalViewF!)
//----------------------------------------计算转发微博的frame-----------------------------------------------------//
        //转发微博的 frame
        if let retStatus = status.retweeted_status {
            
            //转发微博的内容frame
            let retweetTextLabelX = CELL_CHILD_VIEW_MARGIN
            let retweetTextLabelY = CELL_CHILD_VIEW_MARGIN
            let retweetTextLabelSize = retStatus.text?.size(UIFont.systemFontOfSize(CELL_STATUS_TEXT_FONT), constrainedToSize: CGSizeMake(SCREEN_W - 2 * CELL_CHILD_VIEW_MARGIN, CGFloat(MAXFLOAT)))
            retweetTextLabelF = CGRect(origin: CGPointMake(retweetTextLabelX, retweetTextLabelY), size: retweetTextLabelSize!)
            
            var retweetViewH = CGRectGetMaxY(retweetTextLabelF!)
            //转发微博的图片 frame
            if let retweetPhotosUrls = retStatus.pic_urls where retStatus.pic_urls?.count>0 {
                let retweetPhotosX = CELL_CHILD_VIEW_MARGIN
                let retweetPhotosY = CGRectGetMaxY(retweetTextLabelF!) + CELL_CHILD_VIEW_MARGIN
                let retweetPhotosSize = IWStatusPhotos.size(retweetPhotosUrls.count)
                retweetPhotosF = CGRect(origin: CGPointMake(retweetPhotosX, retweetPhotosY), size: retweetPhotosSize)
                retweetViewH = CGRectGetMaxY(retweetPhotosF!)
            }
            
            //转发整体 view的 frame
            let retweetViewX = CGFloat(0)
            let retweetViewY = CGRectGetMaxY(textF!) + CELL_CHILD_VIEW_MARGIN
            let retweetViewW = SCREEN_W
            retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH)
            
            //重新计算底部 toolBar的y
            statusToolBarY = CGRectGetMaxY(retweetViewF!)
        }
        
//----------------------------------------计算底部toolBar微博的frame-----------------------------------------------------//
        //底部 toolBar 的大小
        let statusToolBarX :CGFloat = 0
        let statusToolBarSize = CGSizeMake(SCREEN_W, 35)
        statusToolBarF = CGRect(origin: CGPointMake(statusToolBarX, statusToolBarY), size: statusToolBarSize)
        
        //cell的高度
        cellHeight = CGRectGetMaxY(statusToolBarF!)
    }
}
