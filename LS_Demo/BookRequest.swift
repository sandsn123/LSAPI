//
//  PersonInfoRequest.swift
//  New_yanzhibuluo
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

struct BookRequest: BaseRequestProtocol {
    typealias Parameter = Void
    
    func relativePath(for parameter: Parameter) -> String {
        return "/books"
    }
    
    func query(from parameter: Parameter) -> String? {
        return nil
    }
    
}
