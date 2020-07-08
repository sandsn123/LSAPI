
import Foundation
import RxSwift
//import Alamofire
//
//public class AlamofireExecutor: ExecutorType {
//    public static let instance = AlamofireExecutor()
//
//    private var validations: [Alamofire.DataRequest.Validation] = []
//
//    private init() {}
//
//    public func execute(urlRequest: URLRequest, multipartFormData: MultipartFormData?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable {
//        if let multipartFormData = multipartFormData {
//            return doExecute(urlRequest: urlRequest, multipartFormData: multipartFormData, completionHandler: completionHandler)
//        } else {
//            return doExecute(urlRequest: urlRequest, completionHandler: completionHandler)
//        }
//    }
//}
//
//extension AlamofireExecutor {
//    public func addValidation(_ validation: @escaping Alamofire.DataRequest.Validation) {
//        self.validations.append(validation)
//    }
//}
//
//extension DataRequest {
//    fileprivate func addValidations(_ validations: [Alamofire.DataRequest.Validation]) -> Self {
//        return validations.reduce(self) { (dataRequest, validation) in
//            return dataRequest.validate(validation)
//        }
//    }
//}
//
//extension AlamofireExecutor {
//    fileprivate func doExecute(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable {
//        let dataRequest = AF
//            .request(urlRequest)
//            .addValidations(self.validations)
//            .response { completionHandler($0.data, $0.response, $0.error) }
//
//        return AnonymousCancelable {
//            dataRequest.cancel()
//        }
//    }
//
//    fileprivate func doExecute(urlRequest: URLRequest, multipartFormData: @escaping MultipartFormData, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable {
//        let serialCancelable = SerialCancelable()
//        let validations = self.validations
//
//        AF.upload(multipartFormData: { (formData) in
//
//            for bodyPart in multipartFormData() {
//                formData.append(bodyPart.bodyStream, withLength: bodyPart.bodyContentLength, headers: bodyPart.headers)
//            }
//        }, with: urlRequest)
//        .addValidations(validations)
//            .response { (response) in
//                switch response.result {
//                case .failure(let error):
//                    completionHandler(nil, nil, error)
//                case .success(let data):
//                    completionHandler(data, response.response, response.error)
//                }
//        }
//
//        return AnonymousCancelable {
//            serialCancelable.cancel()
//        }
//    }
//}

fileprivate class SerialCancelable: Cancelable {
    private var isCanceled: Bool = false
    
    var cancelable: Cancelable? {
        didSet {
            oldValue?.cancel()
            
            if self.isCanceled {
                self.cancelable?.cancel()
            }
        }
    }
    
    func cancel() {
        if self.isCanceled {
            return
        }
        
        self.isCanceled = true
        self.cancelable?.cancel()
    }
}

//extension DefaultEngine {
//    public static let alamofireEngine: DefaultEngine = DefaultEngine(executor: AlamofireExecutor.instance)
//}

