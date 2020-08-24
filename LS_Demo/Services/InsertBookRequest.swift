//
//  InsertBookRequest.swift
//  New_yanzhibuluo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 mac. All rights reserved.
//



import Foundation
import LSAPI
struct InsertBookRequest: BaseRequestProtocol {
    struct Book {
        let name: String
        let price: String
    }
    typealias Parameter = Book
    var method: HTTPMethod = .post

    func data(from parameter: Parameter) -> Data? {
        var query: [String] = []
        query.append("name=\(parameter.name)")
        query.append("price=\(parameter.price)")
        return query.joined(separator: "&")
            .data(using: .utf8, allowLossyConversion: false)
    }
    
    func relativePath(for parameter: Parameter) -> String {
        return "/books"
    }
    
    func query(from parameter: Parameter) -> String? {
        return nil
    }
}
