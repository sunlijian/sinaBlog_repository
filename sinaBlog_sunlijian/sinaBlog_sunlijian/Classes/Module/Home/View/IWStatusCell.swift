//
//  IWStatusCell.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/15.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWStatusCell: UITableViewCell {

    var statusFrame: IWStatusFrame? {
        didSet {
            setStatusFrame()
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //设置 contentView 的背景颜色
        contentView.backgroundColor = RGB(r: 240, g: 240, b: 240)
        //原创微博的整体 View
        contentView.addSubview(originalView)
        //转发的微博 整体 View
        contentView.addSubview(retweetView)
        //评论转发赞的整体 View
        contentView.addSubview(statusToolBar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
//----------------------------------------------微博原创 view的加载-----------------------------------//
    private lazy var originalView:UIView = {
        let view = UIView()
        //设置原创的颜色
        view.backgroundColor = UIColor.whiteColor()
        //添加头像
        view.addSubview(self.headImageView)
        //添加姓名
        view.addSubview(self.nameLabel)
        //添加会员图标
        view.addSubview(self.vipImageView)
        //添加创建时间
        view.addSubview(self.created_atLabel)
        //添加来源
        view.addSubview(self.sourceLabel)
        //添加内容
        view.addSubview(self.originalTextLabel)
        //添加图片
        view.addSubview(self.originalPhotos)
        return view
    }()
    //原创 头像懒加载
    private lazy var headImageView:UIImageView = {
        let imageView = UIImageView()
        //设置边线
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    //原创 姓名的加载
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(CELL_STATUS_NAME_FONT)
        return label
    }()
    private lazy var vipImageView = UIImageView()
    //原创 时间的加载
    private lazy var created_atLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(CELL_STATUS_CREATE_AT_FONT)
        label.textColor = UIColor.darkGrayColor()
        return label
    }()
    //原创 来源的加载
    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(CELL_STATUS_CREATE_AT_FONT)
        label.textColor = UIColor.darkGrayColor()
        return label
    }()
    //原创 内容
    private lazy var originalTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(CELL_STATUS_TEXT_FONT)
        label.numberOfLines = 0
        return label
    }()
    //原创的 图片
    private lazy var originalPhotos: IWStatusPhotos = IWStatusPhotos()
    
//------------------------------------------------------加载转发微博------------------------------------------//
    //转发的微博的整体 View的加载
    private lazy var retweetView: UIView = {
        let view = UIView()
        view.backgroundColor = RGB(r: 244, g: 244, b: 244)
        //添加转发微博内容的 label
        view.addSubview(self.retweetViewLabel)
        //添加转发微博的图片
        view.addSubview(self.retweetPhotos)
        return view
    }()
    //转发微博 label
    private lazy var retweetViewLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(CELL_STATUS_TEXT_FONT)
        return label
    }()
    //转发微博的 图片
    private lazy var retweetPhotos: IWStatusPhotos = IWStatusPhotos()
    
//--------------------------------------------------------加载底部 toolBar-----------------------------------//
    //转发评论赞的加载
    private lazy var statusToolBar: IWStatusToolBar = IWStatusToolBar()

    
//----------------------------------------------------------赋值操作---------------------------------------//
    //设置 frame
    private func setStatusFrame(){
        let statusF = statusFrame!
        let status = statusF.status!
//----------------------------------------原创微博的赋值-----------------------------------------------------//
        //设置整体 view 的 frame
        originalView.frame = statusF.originalViewF!
        
        //设置 原创头像
        headImageView.frame = statusF.headImageViewF!
        headImageView.sd_setImageWithURL(NSURL(string: (status.user?.profile_image_url)!), placeholderImage: UIImage(named: "avatar_default_big"))
        //设置 原创姓名
        nameLabel.frame = statusF.nameLableF!
        nameLabel.text = status.user?.name
        //设置会员的
        if status.user!.isVip{
            vipImageView.hidden = false
            //设置 frame
            vipImageView.frame = statusF.vipImageViewF!
            vipImageView.image = UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
            nameLabel.textColor = UIColor.orangeColor()
        }else{
            vipImageView.hidden = true
            nameLabel.textColor = UIColor.blackColor()
        }
        //设置 原创创建时间
        created_atLabel.frame = statusF.created_atF!
        created_atLabel.text = status.created_at
        //设置 原创来源
        sourceLabel.frame = statusF.sourceF!
        sourceLabel.text = status.source
        //设置 原创内容
        originalTextLabel.frame = statusF.textF!
        originalTextLabel.attributedText = status.attributedText
        
//        originalTextLabel.text = status.text
        //设置 原创的图片
        if let originalPhotosUrls = status.pic_urls where originalPhotosUrls.count>0{
            originalPhotos.hidden = false
            //设置 frame 
            originalPhotos.frame = statusF.originalPhotosF!
            originalPhotos.pic_urls = originalPhotosUrls
        }else{
            originalPhotos.hidden = true
        }
        
        
//----------------------------------------转发微博的赋值-----------------------------------------------------//
        //设置转发微博的内容
        if let retStatus = status.retweeted_status{
            
            //有转发微博就显示
            retweetView.hidden = false
            //转发微博整体 view
            retweetView.frame = statusF.retweetViewF!
            //转发微博的内容
            retweetViewLabel.frame = statusF.retweetTextLabelF!
            retweetViewLabel.attributedText = retStatus.attributedText
            //转发微博的图片
            if let retweetPhotosUrls = retStatus.pic_urls where retweetPhotosUrls.count>0{
                retweetPhotos.hidden = false
                //设置 frame 和 图片的 url
                retweetPhotos.frame = statusF.retweetPhotosF!
                retweetPhotos.pic_urls = retweetPhotosUrls
            }else{
                retweetPhotos.hidden = true
            }
            
        }else{
            //没有转发微博就隐藏
            retweetView.hidden = true
        }
//----------------------------------------底部toolBar微博的赋值-----------------------------------------------------//
        //设置底部 statusToolBar的 frame和值
        statusToolBar.frame = statusF.statusToolBarF!
        statusToolBar.status = statusF.status
    }

}
