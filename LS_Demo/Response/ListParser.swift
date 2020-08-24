//
//  ListParser.swift
//  LS_Demo
//
//  Created by sai on 2020/8/24.
//  Copyright © 2020 sai.api.framework. All rights reserved.
//

import Foundation
import HandyJSON
import LSAPI

public struct ListParser<T: HandyJSON>: ParserType {
    public typealias Content = [T]
    
    public func parse(_ data: Data?, response: HTTPURLResponse) throws -> Content {
        guard let data = data, let jsonString = String(data: data, encoding: .utf8) else {
            throw APIError.dataIsNil
        }
        
        guard let response = JSONDeserializer<ResponseListModel<T>>.deserializeFrom(json: jsonString) else {
            throw APIError.parseFailure("解析错误")
        }
        guard response.code == 0, let content = response.data else {
            throw APIError.dataIsNil
        }
        return content
    }
}
