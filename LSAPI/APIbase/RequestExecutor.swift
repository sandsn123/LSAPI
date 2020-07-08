
import Foundation

/// 请求执行器协议
///
/// 可根据需要选择第三方网络组件如`Alamofire`实现，或直接使用`URLSession`实现
public protocol ExecutorType {
    /// 执行请求
    ///
    /// - Parameters:
    ///   - urlRequest: URL请求对象
    ///   - multipartFormData: 多格式数据
    ///   - completionHandler: 请求完成后（成功或失败）回调
    /// - Returns: 用于取消请求的对象
    func execute(urlRequest: URLRequest, multipartFormData: MultipartFormData?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable
}

extension ExecutorType {
    /// 执行请求
    ///
    /// - Parameters:
    ///   - urlRequest: URL请求对象
    ///   - completionHandler: 请求完成后（成功或失败）回调
    /// - Returns: 用于取消请求的对象
    func execute(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable {
        return self.execute(urlRequest: urlRequest, multipartFormData: nil, completionHandler: completionHandler)
    }
}
