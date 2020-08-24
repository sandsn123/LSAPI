//
//  ListModel.swift
//  new_pro
//
//  Created by mac on 2019/10/28.
//  Copyright © 2019 sai. All rights reserved.
//

import Foundation
import HandyJSON

struct List<T: HandyJSON>: HandyJSON {
    var list: [T]?
    var page: Int = 1
    var limit: Int?
}

struct ResponseDataModel<T: HandyJSON>: HandyJSON {
    var code: Int!
    var message: String?
    var data: T?
}

extension ResponseDataModel {
    var isSuccess: Bool {
        return status == .success
    }
    
    var status: Status {
        return Status(rawValue: code)
    }
}

extension List {
    func hasNaxtPage(_ limit: Int?) -> Bool {
        guard let list = self.list, let limit = limit else {
            return false
        }
        return list.count == limit
    }
}

struct NeverModel: HandyJSON {}

enum ResponseCode: Int {
    case success = 0
}
