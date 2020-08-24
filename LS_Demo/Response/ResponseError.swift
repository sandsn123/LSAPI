//
//  ResponseError.swift
//  HuayingAPIBase
//
//  Created by 王义川 on 07/04/2017.
//  Copyright © 2017 肇庆市华盈体育文化发展有限公司. All rights reserved.
//

import Foundation

/// 响应错误
public struct ResponseError {
    /// 状态
    public let status: Status
    /// 提示语
    public let message: String?
    
    /// 构造响应错误
    ///
    /// - Parameters:
    ///   - status: 状态
    ///   - message: 提示语
    public init(status: Status = .responseError, message: String? = nil) {
        self.status = status
        self.message = message
        
    }
}

// MARK: - Error

extension ResponseError: Error {
}

// MARK: - LocalizedError

extension ResponseError: LocalizedError {
    public var errorDescription: String? {
        if let message = self.message {
            return message
        } else {
            return self.status.description
        }
    }
}
