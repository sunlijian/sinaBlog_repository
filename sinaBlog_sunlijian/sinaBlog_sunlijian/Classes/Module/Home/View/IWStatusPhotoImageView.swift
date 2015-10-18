//
//  IWStatusPhotoImageView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/18.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit

class IWStatusPhotoImageView: UIImageView {
    
    private var gifImageView: UIImageView?
    
    var thumbnail_pic: String?{
        didSet{
            if let picUrlString = thumbnail_pic{
                sd_setImageWithURL(NSURL(string: picUrlString), placeholderImage: UIImage(named: "timeline_image_placeholder"))
                if picUrlString.hasSuffix(".gif"){
                    gifImageView?.hidden = false
                }else{
                    gifImageView?.hidden = true
                }
            }
        }
    }
    
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置图片的显示模式
        contentMode = UIViewContentMode.ScaleAspectFill
        //去掉超出部分
        clipsToBounds = true
        
        //设置图片
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        self.gifImageView = gifImageView
        addSubview(gifImageView)
    }
    //调整位置
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gifImageView!.x = width - self.gifImageView!.width
        self.gifImageView!.y = height - self.gifImageView!.height
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
