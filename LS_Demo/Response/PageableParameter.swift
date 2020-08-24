//
//  PageableParameter.swift
//  LS_Demo
//
//  Created by sai on 2020/8/24.
//  Copyright © 2020 sai.api.framework. All rights reserved.
//

import Foundation

/// 支持分页的参数类型
public protocol PageableParameterProtocol: QueryConvertible {
    /// 页码
    var pagination: Pagination { get }
}

// MARK: - PageableParameter

/// 支持分页的参数
public struct PageableParameter<Parameter: QueryConvertible> {
    /// 具体参数
    public let parameter: Parameter
    /// 页码
    public var pagination: Pagination
    
    /// 构造参数
    ///
    /// - Parameters:
    ///   - parameter: 具体参数
    ///   - pagination: 页码
    public init(parameter: Parameter, pagination: Pagination = .first) {
        self.parameter = parameter
        self.pagination = pagination
    }
}

extension PageableParameter: PageableParameterProtocol {
    public func asQuery() -> String? {
        var queries = [String]()
        if let query = parameter.asQuery() {
            queries.append(query)
        }
        if let query = pagination.asQuery() {
            queries.append(query)
        }
        if queries.isEmpty {
            return nil
        }
        return queries.joined(separator: "&")
    }
}

// MARK: - OptionalPageableParameter

/// 支持分页的参数，具体参数可为空
public struct OptionalPageableParameter<Parameter: QueryConvertible> {
    /// 具体参数，可为空
    public let parameter: Parameter?
    /// 页码
    public var pagination: Pagination
    
    /// 构造参数
    ///
    /// - Parameters:
    ///   - parameter: 具体参数
    ///   - pagination: 页码
    public init(parameter: Parameter?, pagination: Pagination = .first) {
        self.parameter = parameter
        self.pagination = pagination
    }
}

extension OptionalPageableParameter: PageableParameterProtocol {
    public func asQuery() -> String? {
        var queries = [String]()
        if let query = parameter?.asQuery() {
            queries.append(query)
        }
        if let query = pagination.asQuery() {
            queries.append(query)
        }
        if queries.isEmpty {
            return nil
        }
        return queries.joined(separator: "&")
    }
}
