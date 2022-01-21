//
//  Dictionary+Extension.swift
//  FZCommonServiceKit
//
//  Created by Jack on 2021/10/8.
//

import Foundation

// MARK: -  操作字典
extension Dictionary {
    
    /// 添加字典
    ///
    /// - Parameter newDictionary: 要添加的字典
    public mutating func fz_Append(_ newDictionary: Dictionary) {
        for (key, value) in newDictionary {
            self[key] = value
        }
    }
    
    /// 判断是否存在key
    ///
    /// - Parameter key: 要判断的key
    /// - Returns: 判断结果
    public func fz_HasKey(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// 删除元素
    ///
    /// - Parameter keys: 要删除的元素的key，为可变参数
    public mutating func fz_Remove(_ keys: Key...) {
        fz_Remove(keys)
    }
    
    /// 删除元素
    ///
    /// - Parameter keys: 要删除的元素的key，为数组
    public mutating func fz_Remove(_ keys: [Key]) {
        for key in keys {
            removeValue(forKey: key)
        }
    }
    
}

// MARK: -  Codable
extension Dictionary where Key: Codable, Value: Codable {
    
    /// 转换为jsonString
    public var fz_JsonString: String? {
        guard let data = try? JSONEncoder().encode(self),
            let jsonString = String(data: data, encoding: .utf8) else {
                return nil
        }
        return jsonString
    }
    
    /// 通过jsonString创建实例
    ///
    /// - Parameter jsonString: jsonString
    public init?(jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8),
            let dictionary = try? JSONDecoder().decode(Dictionary.self, from: jsonData) else {
                return nil
        }
        self = dictionary
    }
    
}
