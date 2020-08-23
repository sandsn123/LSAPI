//
//  ServiceType+Combine.swift
//  CbService
//
//  Created by sai on 2020/7/9.
//  Copyright © 2020 sai.api.framework. All rights reserved.
//

import AlamofireExecutor
import LSAPI
import Combine

public extension ServiceType {
    func asPublisher(parameter: Parameter) -> AnyPublisher<Content, Error> {
        return
            Deferred {
                Future { (promise) in
                    _ = self.call(with: parameter) { result in
                        promise(result.mapToResult())
                    }
                }
            }
            .eraseToAnyPublisher()
    }
}

public extension ServiceType where Parameter == Void {
    func asPublisher() -> AnyPublisher<Content, Error> {
        return self.asPublisher(parameter: ())
    }
}
