//
//  ResponseListModel.swift
//  LS_Demo
//
//  Created by sai on 2020/8/24.
//  Copyright © 2020 sai.api.framework. All rights reserved.
//

import Foundation
import HandyJSON

public struct ResponseListModel<T: HandyJSON> : HandyJSON {
    public init() {
    }
    
    public var code: Int!
    public var message: String!
    public var data: [T]?
}
