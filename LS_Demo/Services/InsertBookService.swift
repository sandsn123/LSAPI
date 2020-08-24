//
//  PostVerityPhotoService.swift
//  New_yanzhibuluo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 mac. All rights reserved.
//

import LSAPI
import HandyJSON
struct InsertBookService: GenericServiceType {
    typealias Request = InsertBookRequest
    
    typealias Parser = SubmitParser

    func getRequest() -> Request {
        return Request()
    }
    func getParser() -> Parser {
        return Parser()
    }
    init() {}
}


struct SubmitParser: ParserType {
    typealias Content = ResponseDataModel<NeverModel>
    
    func parse(_ data: Data?, response: HTTPURLResponse) throws -> Content {
        guard let data = data, let jsonString = String(data: data, encoding: .utf8) else {
            throw APIError.dataIsNil
        }
        
        guard let response = JSONDeserializer<Content>.deserializeFrom(json: jsonString) else {
            throw APIError.parseFailure("解析错误")
        }
        return response
    }
    
}
