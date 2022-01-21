//
//  FZLog.swift
//  FZCommonServiceKit
//
//  Created by Jack on 2021/10/8.
//

import UIKit
import SwifterSwift
/// 自定义log
///
/// - Parameters:
///   - message: 打印信息
///   - filePath: 文件路径
///   - methodName: 方法名
///   - line: 行数
public func FZLog<T>(_ message: T, filePath: String = #file, methodName: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.components(separatedBy: ".").first!
    print("==>> \(fileName).\(methodName)[\(line)]: \(message) \n")
    #endif
}

//MARK: 获取当前视图控制器
public func fz_getCurrentVC() -> UIViewController? {
    let vc = UIApplication.shared.currentKeyWindow?.rootViewController
   
    return findVC(vc: vc)
}
private func findVC(vc : UIViewController?) -> UIViewController? {
    
    guard let vc = vc else {
        return nil
    }

    if let pvc = vc.presentedViewController {
        return findVC(vc: pvc)
    } else if let svc = vc as? UISplitViewController {
        if let lvc = svc.viewControllers.last {
            return findVC(vc: lvc)
        } else {
            return vc
        }
    } else if let nav = vc as? UINavigationController {
        if let tvc = nav.topViewController {
            return findVC(vc: tvc)
        } else {
            return vc
        }
    } else if let tab = vc as? UITabBarController {
        if let svc = tab.selectedViewController {
            return findVC(vc: svc)
        } else {
            return vc
        }
    } else {
        return vc
    }
    
    
}

///  打印类的所有实例变量
///
/// - Parameter aClass: 目标类
public func fz_printIvars(_ aClass: AnyClass) {
    FZLog("开始打印 =======")
    var count: UInt32 = 0
    let ivars = class_copyIvarList(aClass, &count)
    for i in 0 ..< count {
        let ivar = ivars![Int(i)]
        FZLog(String(utf8String: ivar_getName(ivar)!) ?? "")
    }
    free(ivars)
    FZLog("结束打印 =======")
}

///  打印类的所有属性变量
///
/// - Parameter aClass: 目标类
public func fz_printProperties(_ aClass: AnyClass) {
    FZLog("开始打印 =======")
    var count: UInt32 = 0
    let properties = class_copyPropertyList(aClass, &count)
    for i in 0 ..< count {
        let property = properties![Int(i)]
        FZLog(String(utf8String: property_getName(property)) ?? "")
    }
    free(properties)
    FZLog("结束打印 =======")
}

/// 打印类的所有方法
///
/// - Parameter aClass: 目标类
public func fz_printMethods(_ aClass: AnyClass) {
    FZLog("开始打印 =======")
    var count: UInt32 = 0
    let methods = class_copyMethodList(aClass, &count)
    for i in 0 ..< count {
        let method = methods![Int(i)]
        FZLog(method_getName(method))
    }
    free(methods)
    FZLog("结束打印 =======")
}

public func fz_hexStringColor(hexString: String, transparency: CGFloat = 1) -> UIColor {
    guard let color = UIColor(hexString: hexString, transparency: transparency) else {
        return UIColor.red
    }
    return color
}

public func fz_RGBAColor(r: CGFloat,g: CGFloat,b: CGFloat, a: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
