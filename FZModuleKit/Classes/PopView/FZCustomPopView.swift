//
//  FZCustomPopView.swift
//  Gunyu_Pad
//
//  Created by Jack on 2021/11/3.
//

import UIKit
import FZCommitKit

public class FZCustomPopView: NSObject {
    
    /// 自定义popView消失的时候的事件回调
    var dismissCustomPopViewBlock:(() -> Void)?
    
    /// 内容视图
    private var contentVC: UIViewController?
    
    private var popoverLayoutMargins: UIEdgeInsets = .zero
            
    /// 初始化视图
    /// popViewSize 内容视图的尺寸
    /// contentVC 容器视图
    /// parentVC 父视图
    init(popViewSize: CGSize, contentVC: UIViewController, popoverLayoutMargins: UIEdgeInsets = .zero) {
        super.init()
        self.contentVC = contentVC
        self.popoverLayoutMargins = popoverLayoutMargins
        contentVC.view.backgroundColor = .white
        contentVC.preferredContentSize = popViewSize
        contentVC.modalPresentationStyle = .popover
        
        if let popover = contentVC.popoverPresentationController {
            popover.backgroundColor = .white
            popover.delegate = self
        }
    }
        
    /// 触发时候的对象视图，direction方向可调整
    public func showPopView(view: Any? = nil, direction: UIPopoverArrowDirection = .any) {
        guard let vc = contentVC else { return }
        vc.popoverPresentationController?.sourceView = view as? UIView
        vc.popoverPresentationController?.permittedArrowDirections = direction
        vc.popoverPresentationController?.popoverLayoutMargins = self.popoverLayoutMargins
        fz_getCurrentVC()?.present(vc, animated: true, completion: nil)
    }

    /// 手动触发消失
    public func dismissPopView() {
        fz_getCurrentVC()?.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FZCustomPopView: UIPopoverPresentationControllerDelegate {
    
    // 是否允许点击背景消失
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    // 是否允许点击背景消失
    @available(iOS 13.0, *)
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
    
    // 必须设置为none, 否则没有弹窗效果
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    // Dismiss
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if let block = dismissCustomPopViewBlock {
            block()
        }
    }
    
    //Dismiss
    @available(iOS 13.0, *)
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let block = dismissCustomPopViewBlock {
            block()
        }
    }
}

