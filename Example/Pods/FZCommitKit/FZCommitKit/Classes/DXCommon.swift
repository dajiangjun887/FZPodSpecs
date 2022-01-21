//
//  DXCommon.swift
//  FZCommonServiceKit
//
//  Created by Jack on 2021/10/9.
//

import UIKit

public class DXCommon: NSObject {
    /// prefix 开头
    /// suffix 结尾
    open class func fz_MakeAttributeText(prefix: (String, [NSAttributedString.Key: Any]?), suffix: (String, [NSAttributedString.Key: Any]?)) -> NSAttributedString {
        let attributeText = NSMutableAttributedString.init()
        let p1 = NSAttributedString(string: prefix.0, attributes: prefix.1)
        attributeText.append(p1)
        let p2 = NSAttributedString(string: suffix.0, attributes: suffix.1)
        attributeText.append(p2)
        return attributeText
    }
    
    /// prefix 开头
    /// mid    中间
    /// suffix 结尾
    open class func fz_MakeAttributeText(prefix: (String, [NSAttributedString.Key: Any]?), mid: (String, [NSAttributedString.Key: Any]?), suffix: (String, [NSAttributedString.Key: Any]?)) -> NSAttributedString {
        let attributeText = NSMutableAttributedString.init()
        let p1 = NSAttributedString(string: prefix.0, attributes: prefix.1)
        attributeText.append(p1)
        let p2 = NSAttributedString(string: mid.0, attributes: mid.1)
        attributeText.append(p2)
        let p3 = NSAttributedString(string: suffix.0, attributes: suffix.1)
        attributeText.append(p3)
        return attributeText
    }
    
    /// 比较版本大小
    /// 返回-1，newVersion大，需要弹窗更新
    /// 返回0，相等
    /// 返回1，nowVersion大
    public func fz_CompareVersion(nowVersion: String, newVersion: String) -> Int {
        var numbers1 = nowVersion.split(separator: ".").compactMap { Int(String($0)) }
        var numbers2 = newVersion.split(separator: ".").compactMap { Int(String($0)) }
        let numDiff = numbers1.count - numbers2.count
        
        if numDiff < 0 {
            numbers1.append(contentsOf: Array(repeating: 0, count: -numDiff))
        } else if numDiff > 0 {
            numbers2.append(contentsOf: Array(repeating: 0, count: numDiff))
        }
        
        for i in 0..<numbers1.count {
            let diff = numbers1[i] - numbers2[i]
            if diff != 0 {
                return diff < 0 ? -1 : 1
            }
        }
        return 0
    }
    
    /// 获取当前时间
    static func getNowYMD(_ type: String = "yyyy-MM-dd") -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = type
        let time = formatter.string(from: currentDate)
        return time
    }
    
    
    // 获取今天之前的日期
    /// fewDays(例如7天之前传7)
    /// 多少天之后 TimeInterval(time)
    /// 多少天之前 -TimeInterval(time)
    static func getBeforeTodayDate(fewDays: TimeInterval) -> String {
        let currentDate = Date()
        // n天后的天数
        let days: TimeInterval = fewDays
        let oneDay: TimeInterval = 24 * 60 * 60
        let time = oneDay * days
        let appointDate: Date = type(of: currentDate).init(timeIntervalSinceNow: -TimeInterval(time))
        let dateStr = appointDate.fz_String(with: "yyyy-MM-dd")
        return dateStr
    }

    /// 字符串转时间
    /// dateStr当前日期的字符串（例如：2022-01-06）
    static func StringConversionTime(dateStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "Asia/Shanghai") as TimeZone?
        guard let date = formatter.date(from: dateStr) else { return Date() }
        return date
    }
    
    /// 开始日期不能大于结束日期
    static func isGreaterThanStartTime(startTime: String, endTime: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let tempStart = formatter.date(from: startTime) else { return false }
        guard let tempStop = formatter.date(from: endTime) else { return false }
        let intervalStart = tempStart.timeIntervalSince1970
        let intervalStop = tempStop.timeIntervalSince1970
        if intervalStart > intervalStop {
            return true
        }
        return false
    }
    
    
    // (例子)开始和结束时间相距不能超过7天
//    let stratDate = DXCommon.StringConversionTime(dateStr: startTime)
//    let endDate = DXCommon.StringConversionTime(dateStr: endTime)
//    let days: Int = stratDate.dx_numberOfdays(to: endDate)
//
//    if days > 7 {
//        return
//    }
}
