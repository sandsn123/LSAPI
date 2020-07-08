
import Foundation

/// 描述接口的通用协议
///
/// 描述具体接口，如接口使用的HTTP方法，基础地址、相对地址、查询参数、超时时间等等
public protocol GenericRequestType: RequestType {
    /// HTTP请求的方法
    var method: HTTPMethod { get }
    
    /// 基础地址
    var baseURL: URL { get }
    
    /// 超时时间，`nil`表示使用默认配置
    var timeoutInterval: TimeInterval? { get }

    /// 相对地址
    ///
    /// - Parameter parameter: 参数
    /// - Returns: 地址
    func relativeString(fill parameter: Parameter) -> String

    /// 从参数中获取需要的数据生成消息体数据
    ///
    /// - Parameter parameter: 参数
    /// - Returns: 消息体数据
    func data(from parameter: Parameter) -> Data?
}

// MARK: - 默认实现

extension GenericRequestType {
    public var timeoutInterval: TimeInterval? {
        // 使用默认配置
        return nil
    }
}

// MARK: - 为RequestType提供默认实现

extension GenericRequestType {
    public func generateURLRequest(with parameter: Parameter) -> URLRequest {
        let relativeString = self.relativeString(fill: parameter)
        let url = URL(string: relativeString, relativeTo: self.baseURL)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.httpBody = self.data(from: parameter)
        if let timeoutInterval = self.timeoutInterval {
            urlRequest.timeoutInterval = timeoutInterval
        }
        return urlRequest
    }
}
