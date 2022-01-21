//
//  UIControl+Extension.swift
//  FZCommonServiceKit
//
//  Created by Jack on 2021/10/9.
//

import Foundation

private var UIControlActionHandlerKey = "UIControlActionHandlerKey"

public extension UIControl {
    /// events 事件类型
    /// click 在回调里面处理点击事件，替换系统的addTarget方法
    @objc func fz_HandleClick(events: UIControl.Event, click: ((UIControl) -> ())?){
        objc_setAssociatedObject(self, &UIControlActionHandlerKey, click, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(fz_HandleClickEvent(_:)), for: events)
    }
    
    @objc private func fz_HandleClickEvent(_ sender: UIControl){
        let handler: ((UIControl) -> Void)?=objc_getAssociatedObject(self, &UIControlActionHandlerKey) as? ((UIControl) -> Void)
        guard handler != nil else { return }
        handler!(sender)
    }
}
