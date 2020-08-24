//
//  EditBookService.swift
//  New_yanzhibuluo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 mac. All rights reserved.
//
import LSAPI
struct EditBookService: GenericServiceType {
    typealias Request = EditBookRequest
    
    typealias Parser = SubmitParser

    func getRequest() -> Request {
        return Request()
    }
    func getParser() -> Parser {
        return Parser()
    }
    init() {}
}

