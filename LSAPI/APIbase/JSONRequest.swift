

import Foundation

public protocol JSONRequestType: GenericRequestType {

}

extension JSONRequestType {
    public func generateURLRequest(with parameter: Parameter) -> URLRequest {
        let relativeString = self.relativeString(fill: parameter)
        let url = URL(string: relativeString, relativeTo: self.baseURL)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.httpBody = self.data(from: parameter)
        if let timeoutInterval = self.timeoutInterval {
            urlRequest.timeoutInterval = timeoutInterval
        }
        urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
