//
//  Status.swift
//  HuayingAPIBase
//
//  Created by 王义川 on 07/04/2017.
//  Copyright © 2017 肇庆市华盈体育文化发展有限公司. All rights reserved.
//

import Foundation

/// 状态
public struct Status: RawRepresentable {
    public typealias RawValue = Int
    
    public let rawValue: RawValue
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

// MARK: - Built-in

extension Status {
    /// 成功
    public static let success = Status(rawValue: 0)
    /// 返回错误
    public static let responseError = Status(rawValue: 1)
    /// 数据错误
    public static let dataError = Status(rawValue: 10000)
}

// MARK: - CustomStringConvertible

extension Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case Status.success: return "成功"
        case Status.responseError: return "返回错误"
        case Status.dataError: return "数据错误"
        default:
            return "状态码：\(self.rawValue)"
        }
    }
}

// MARK: - Equatable

extension Status: Equatable {
    public static func ==(lhs: Status, rhs: Status) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
