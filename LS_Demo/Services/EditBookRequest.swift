//
//  EditHeadImageRequest.swift
//  New_yanzhibuluo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import LSAPI

struct EditBookRequest: BaseRequestProtocol {
    
    typealias Parameter = Book
    
    var method: HTTPMethod = .put
    
    
    func buildMultipartFormData(with parameter: Parameter) -> MultipartFormData? {
        return {
            var bodyParts: [BodyPart] = []
            bodyParts.append(BodyPart(string: parameter.name, name: "name"))
            bodyParts.append(BodyPart(string: parameter.price, name: "price"))
            return bodyParts
        }
    }
    
    func relativePath(for parameter: Parameter) -> String {
        return "/user"
    }
    
    func query(from parameter: Parameter) -> String? {
        return "book_id=\(parameter.id.description)"
    }
}
