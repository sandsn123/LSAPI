//
//  PersonInfoService.swift
//  New_yanzhibuluo
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 mac. All rights reserved.
//

import LSAPI

struct GetBookService: GenericServiceType {
    
    typealias Request = GetBookRequest
    
    typealias Parser = ListParser<Book>

    func getRequest() -> Request {
        return Request()
    }
    func getParser() -> Parser {
        return Parser()
    }
    init() {}
}

struct GetBookParser: ParserType {
    func parse(_ data: Data?, response: HTTPURLResponse) throws -> String {
        guard let data = data, let jsonString = String(data: data, encoding: .utf8) else {
            throw APIError.dataIsNil
        }
        return jsonString
    }
    
    typealias Content = String
    
    
}
