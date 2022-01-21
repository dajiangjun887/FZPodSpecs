//
//  UIScreen+Extension.swift
//  FZCommonServiceKit
//
//  Created by Jack on 2021/10/8.
//

import UIKit

///根据currentKeyWindow的safeAreaInsets进行的适配必须在已经设置了keyWindow之后才能获取到正确尺寸
public extension UIScreen {
    /// 屏幕宽度
    static var kScreenWidth: CGFloat {
       return UIScreen.main.bounds.width
    }
    
    /// 屏幕高度
    static var kScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    /// 导航高度
    static var kNavBarHeight: CGFloat {
        let navBar = UINavigationController().navigationBar
        return navBar.frame.size.height + safeAreaTopHeight
    }
    
    /// tabbar高度
    static var kTabbarHeight: CGFloat {
        let tabbar = UITabBarController().tabBar
        return tabbar.frame.size.height + safeAreaBottomHeight
    }

    /// 标准屏幕比例
    static var scaleSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return kScreenWidth / 640.0
        }
        /// iPhone
        return kScreenWidth / 375.0
    }
    
    /// 安全区域高度
    static var safeAreaHeight: CGFloat {
        if #available(iOS 11.0, *) {
            guard let safeInsets = UIApplication.shared.currentKeyWindow?.safeAreaInsets else {
                return 0
            }
            return kScreenHeight - safeInsets.top - safeInsets.bottom
        }
        return kScreenHeight
    }
    
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        
        var height: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager
            height = statusBarManager?.statusBarFrame.height ?? 44
            
        } else {
            height = UIApplication.shared.statusBarFrame.height
        }
        return height
    }
    
    /// 安全区域底部高度
    static var safeAreaBottomHeight: CGFloat {
        if #available(iOS 11.0, *) {
            guard let safeInsets = UIApplication.shared.currentKeyWindow?.safeAreaInsets else {
                return 0
            }
            return safeInsets.bottom
        }
        return 0
    }
    
    /// 安全区域顶部高度
    static var safeAreaTopHeight: CGFloat {
        if #available(iOS 11.0, *) {
            guard let safeInsets = UIApplication.shared.currentKeyWindow?.safeAreaInsets else {
                return 0
            }
            return safeInsets.top
        }
        return 0
    }
}

public extension UIApplication {
    
    var currentKeyWindow: UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
        } else {
            window = UIApplication.shared.keyWindow
        }
        return window
    }
}

public extension Int {
    
    var fit: CGFloat {
        return UIScreen.scaleSize * CGFloat(self)
    }
    
    /// 以下为字体适配
    var regularPFFont: UIFont {
        guard let font = UIFont(name: "PingFangSC-Regular", size: self.fit) else {
            return UIFont.systemFont(ofSize: self.fit)
        }
        return font
    }
    
    var semiboldPFFont: UIFont {
        guard let font = UIFont(name: "PingFangSC-Semibold", size: self.fit) else {
            return UIFont.systemFont(ofSize: self.fit)
        }
        return font
    }

    var mediumPFFont: UIFont {
        guard let font = UIFont(name: "PingFangSC-Medium", size: self.fit) else {
            return UIFont.systemFont(ofSize: self.fit)
        }
        return font
    }

    var dinAlternateBoldFont: UIFont {
        guard let font = UIFont(name: "DINAlternate-Bold", size: self.fit) else {
            return UIFont.systemFont(ofSize: self.fit)
        }
        return font
    }
}

public extension CGFloat {
    
    var fit: CGFloat {
        return UIScreen.scaleSize * CGFloat(self)
    }

}

public extension Double {
    
    var fit: CGFloat {
        return UIScreen.scaleSize * CGFloat(self)
    }
}
