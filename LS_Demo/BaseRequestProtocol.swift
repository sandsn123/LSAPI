//
//  BaseRequestProtocol.swift
//  LS_Demo
//
//  Created by sai on 2020/7/9.
//  Copyright © 2020 sai.api.framework. All rights reserved.
//

import LSAPI
/// 基础接口
protocol BaseRequestProtocol: GenericRequestType {
    /// 从参数中获取需要的数据生成相对路径
    ///
    /// - Parameter parameter: 参数
    /// - Returns: 相对路径
    func relativePath(for parameter: Parameter) -> String
    
    /// 从参数中获取需要的数据生成查询字符串
    ///
    /// - Parameter parameter: 参数
    /// - Returns: 查询字符串
    func query(from parameter: Parameter) -> String?
}

extension BaseRequestProtocol {
    var baseURL: URL {
        return URL(string: "http://localhost:8090")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    func data(from parameter: Parameter) -> Data? {
        return nil
    }
    
    func relativeString(fill parameter: Parameter) -> String {
        let relativePath = self.relativePath(for: parameter)
        if let query = self.query(from: parameter), !query.isEmpty {
            return "\(relativePath)?\(query)"
        } else {
            return relativePath
        }
    }
}

extension BaseRequestProtocol where Parameter: QueryConvertible {
    func query(from parameter: Parameter) -> String? {
        return parameter.asQuery()
    }
}

extension BaseRequestProtocol where Parameter == Void {
    func query(from parameter: Parameter) -> String? {
        return nil
    }
}

/// 可转换为查询参数协议
public protocol QueryConvertible {
    /// 转换为查询参数
    ///
    /// - Returns: 查询参数
    func asQuery() -> String?
}
