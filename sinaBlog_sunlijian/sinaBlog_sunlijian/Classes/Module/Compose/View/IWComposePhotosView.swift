//
//  IWComposePhotosView.swift
//  sinaBlog_sunlijian
//
//  Created by sunlijian on 15/10/22.
//  Copyright © 2015年 myCompany. All rights reserved.
//

import UIKit
//子控件的间距
let COMPOSE_PHOTOS_MAGIN: CGFloat = 10

class IWComposePhotosView: UIView {
    //定义一个闭包
    var addButtonClickBlock: (() -> ())?
    //计算有多少图片 计算型
    var images: [UIImage] {
        var images = [UIImage]()
        for value in subviews{
            if let imageView = value as? UIImageView where imageView.image != nil {
                images.append(imageView.image!)
            }
        }
        return images
    }
    
    
    //定义一个 bool 类型
    var isAddImage:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.redColor()
        
        //添加加号按钮
        addSubview(addButton)
    }
    
    
    //加号按钮的懒加载
    private lazy var addButton: UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: "addButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        button.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        
        return button
    }()
    //点击的时候执行闭包
    @objc private func addButtonClick(){
        if let block = addButtonClickBlock{
            block()
        }
    }
    //添加图片的方法
    func addImage(image: UIImage){
        
        let imageView = IWComposePhotoView(image: image)
        addSubview(imageView)
        
        insertSubview(imageView, belowSubview: addButton)
        
        isAddImage = true
    }
    
    
    //调整子控件的位置与大小
    override func layoutSubviews() {
        super.layoutSubviews()
        //子控件的 size
        let colMax = 3
        let childViewWH = (width - 2 * COMPOSE_PHOTOS_MAGIN) / CGFloat(colMax)
        
        for (index, value) in subviews.enumerate(){
            //行索引和列索引
            let rowIndex = index / colMax
            let colIndex = index % colMax
            value.size = CGSizeMake(childViewWH, childViewWH)
            
            //判断 加号 button 是否隐藏
            addButton.hidden = (subviews.count == 1 || subviews.count == 10)
            
            
            //如果 value 是imageView 控件
            if !(value == addButton) {
                if isAddImage {
                    //如果是添加图片的吗
                    value.x = (COMPOSE_PHOTOS_MAGIN + childViewWH) * CGFloat(colIndex)
                    value.y = (COMPOSE_PHOTOS_MAGIN + childViewWH) * CGFloat(rowIndex)
                }else{
                    //如果是删除图片的话
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        
                        value.x = (COMPOSE_PHOTOS_MAGIN + childViewWH) * CGFloat(colIndex)
                        value.y = (COMPOSE_PHOTOS_MAGIN + childViewWH) * CGFloat(rowIndex)
                    })
                    isAddImage = false
                }
            }else{//如果 value 是 button 控件
                
                if isAddImage{
                    //如果是添加图片
                    value.x = (COMPOSE_PHOTOS_MAGIN + childViewWH) * CGFloat(colIndex)
                    value.y = (COMPOSE_PHOTOS_MAGIN + childViewWH) * CGFloat(rowIndex)
                }else{
                    //如果是删除图片的话
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        
                        value.x = (COMPOSE_PHOTOS_MAGIN + childViewWH) * CGFloat(colIndex)
                        value.y = (COMPOSE_PHOTOS_MAGIN + childViewWH) * CGFloat(rowIndex)
                    })
                    isAddImage = false
                }
                
            }
        }
    }
    override func willRemoveSubview(subview: UIView) {
        isAddImage = false
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
