//
//  UITextField+Extension.swift
//  FZCommonServiceKit
//
//  Created by Jack on 2021/10/8.
//

import UIKit

extension UITextField {

    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, w: w, h: h, fontSize: 17)
    }
    
    /// 便利构造器，初始化使用
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        font = UIFont.systemFont(ofSize: fontSize)
        backgroundColor = .clear
        clipsToBounds = true
        textAlignment = .left
        isUserInteractionEnabled = true
    }

    /// 添加文字距离左侧的间隙
    public func dx_AddLeftTextPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = .always
    }

    /// 添加testField左侧的图片
    public func dx_AddLeftIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: (frame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = .always
    }

}
