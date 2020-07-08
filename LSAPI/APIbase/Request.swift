
import Foundation

/// 描述接口的协议
///
/// 描述具体接口，提供根据具体参数生成`URLRequest`的方法
public protocol RequestType {
    associatedtype Parameter
    
    /// 结合指定参数生成`URLRequest`
    ///
    /// - Parameter parameter: 参数
    /// - Returns: `URLRequest`
    func generateURLRequest(with parameter: Parameter) -> URLRequest
    
    /// 结合指定参数生成`MultipartFormData`
    ///
    /// - Parameter parameter: 参数
    /// - Returns: `MultipartFormData`
    func buildMultipartFormData(with parameter: Parameter) -> MultipartFormData?
}

public extension RequestType {
    func buildMultipartFormData(with parameter: Parameter) -> MultipartFormData? {
        return nil
    }
}
