
import Foundation

/// 接口服务协议
public protocol ServiceType {
    associatedtype Parameter
    associatedtype Content
    
    /// 调用接口 for RxSwift
    ///
    /// - Parameters:
    ///   - parameter: 参数
    ///   - engine: 执行引擎
    ///   - completionHandler: 回调函数
    /// - Returns: 取消请求
    func call(with parameter: Parameter, use engine: EngineType, completionHandler: @escaping (APIResult<Content>) -> Void) -> Cancelable
}

extension ServiceType where Parameter == Void {
    public func call(use engine: EngineType, completionHandler: @escaping (APIResult<Content>) -> Void) -> Cancelable {
        return self.call(with: (), use: engine, completionHandler: completionHandler)
    }
}

/// 简单的接口服务协议，指定了使用哪个接口和解析器
public protocol GenericServiceType: ServiceType {
    associatedtype Request: RequestType
    associatedtype Parser: ParserType
    
    func getRequest() -> Request
    func getParser() -> Parser
}

extension GenericServiceType {
    public func call(with parameter: Request.Parameter, use engine: EngineType, completionHandler: @escaping (APIResult<Parser.Content>) -> Void) -> Cancelable {
        return engine.call(getRequest(), with: parameter, parsedBy: getParser(), completionHandler: completionHandler)
    }
}
