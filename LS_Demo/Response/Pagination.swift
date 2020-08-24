//
//  Pagination.swift
//  new_pro
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 sai. All rights reserved.
//

import Foundation
/// 页码协议
public protocol PaginationProtocol: QueryConvertible {
}

/// 页码
public struct Pagination {
    /// 第几页（从1开始）
    public let index: Int
    
    /// 构造页码
    ///
    /// - Parameter index: 第几页（从1开始），默认为1
    public init(index: Int = 1) {
        self.index = max(index, 1)
    }
}

extension Pagination {
    /// 首页
    public static let first = Pagination()
    
    /// 计算页码
    ///
    /// - Parameter n: 增加的页数
    /// - Returns: 页码
    public func advanced(by n: Int) -> Pagination {
        return Pagination(index: self.index + n)
    }
    
    /// 获取下一页
    ///
    /// - Returns: 下一页
    public func next() -> Pagination {
        return self.advanced(by: 1)
    }
}

// MARK: - Equatable
extension Pagination: Equatable {
    public static func ==(lhs: Pagination, rhs: Pagination) -> Bool {
        return lhs.index == rhs.index
    }
}

// MARK: - PaginationProtocol

extension Pagination: PaginationProtocol {
    public func asQuery() -> String? {
        if self == .first {
            return nil
        }
        return "page=\(index)"
    }
}
