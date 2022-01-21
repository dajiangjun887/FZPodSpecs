//
//  UIButton+Extension.swift
//  Dicos
//
//  Created by Jack on 2021/8/12.
//

import UIKit

public typealias fz_ActionBlock = ((UIButton) -> Void)

public extension UIButton {
    
    enum fz_ButtonImagePosition: Int {
        case top = 0
        case left
        case bottom
        case right
    }
    
    // Can be called when initializing the object
    convenience init(imageName: String, title: String, type: fz_ButtonImagePosition, space: CGFloat) {
        self.init()
        fz_setCommonFuntion(imageName: imageName, title: title, type: type, space: space)
    }
    
    // Object method call
    func fz_setImageAndTitlePosition(imageName: String, title: String, type: fz_ButtonImagePosition, space: CGFloat)  {
        fz_setCommonFuntion(imageName: imageName, title: title, type: type, space: space)
    }
    
    
    private func fz_setCommonFuntion(imageName: String, title: String, type: fz_ButtonImagePosition, space: CGFloat) {
        setTitle(title, for: .normal)
        setImage(UIImage(named:imageName), for: .normal)
        
        let imageWith: CGFloat = (self.imageView?.frame.size.width)!
        let imageHeight: CGFloat = (self.imageView?.frame.size.height)!
      
        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0

        labelWidth = CGFloat(self.titleLabel!.intrinsicContentSize.width)
        labelHeight = CGFloat(self.titleLabel!.intrinsicContentSize.height)

        var  imageEdgeInsets: UIEdgeInsets = UIEdgeInsets()
        var  labelEdgeInsets: UIEdgeInsets = UIEdgeInsets()
       
        switch type {
            case .top:
                imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space/2.0, left: 0, bottom: 0, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight-space/2.0, right: 0)
                break;
            case .left:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0)
                break;
            case .bottom:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth)
                labelEdgeInsets = UIEdgeInsets(top: -imageHeight-space/2.0, left: -imageWith, bottom: 0, right: 0)
                break;
            case .right:
                imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0)
                labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith-space/2.0, bottom: 0, right: imageWith+space/2.0)
                break;
        }
    
        imageView?.contentMode = .scaleAspectFill
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}

extension UIButton {
    /** 部分圆角
     * - corners: 需要实现为圆角的角，可传入多个
     * - radii: 圆角半径
     */
    public func fz_BtnRoundingCorners(_ corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    // 防重点击，设置间隔时间
    private struct AssociatedKeys {
        static var ActionBlock = "ActionBlock"
        static var ActionDelay = "ActionDelay"
    }
    
    /// Runtime
    private var actionBlock: fz_ActionBlock? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ActionBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionBlock) as? fz_ActionBlock
        }
    }
    
    private var actionDelay: TimeInterval {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ActionDelay, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionDelay) as? TimeInterval ?? 0
        }
    }
    
    /// Close button interaction plus delay operation
    @objc func btnDelayClick(_ button: UIButton) {
        actionBlock?(button)
        isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + actionDelay) { [weak self] in
            print("恢复时间\(Date())")
            self?.isEnabled = true
        }
    }
        
    /// Anti-duplicate click event callback called by external button object
   public func fz_addActionBlock(_ delay: TimeInterval = 0, action: @escaping fz_ActionBlock) {
        addTarget(self, action: #selector(btnDelayClick(_:)) , for: .touchUpInside)
        actionDelay = delay
        actionBlock = action
    }
    
}
