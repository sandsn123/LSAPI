
import Foundation

/// 引擎协议，主要是封装请求的流程
public protocol EngineType {
    /// 执行请求
    ///
    /// - Parameters:
    ///   - request:            要执行的接口
    ///   - parameter:          接口参数
    ///   - executor:           请求执行器
    ///   - parser:             数据解析器
    ///   - completionHandler:  回调函数
    /// - Returns: 用于取消执行的句柄对象
    func call<Request: RequestType, Parser: ParserType>(_ request: Request, with parameter: Request.Parameter, parsedBy parser: Parser, completionHandler: @escaping (APIResult<Parser.Content>) -> Void) -> Cancelable
    
}

/// 默认请求引擎
open class DefaultEngine {
    /// url请求加工器
    public typealias Processor = (URLRequest) throws -> URLRequest
    /// 响应内容验证器
    public typealias Validator = (URLRequest, HTTPURLResponse, Data) throws -> Void
    /// 监听器
    public typealias Monitor = (MonitorEvent) -> Void
    
    /// 监听事件
    ///
    /// - preRequest:   执行请求之前
    /// - postRequest:  执行请求之后
    /// - onResponse:   请求返回响应时
    public enum MonitorEvent {
        case preRequest(URLRequest)
        case postRequest(URLRequest)
        case onResponse(Data?, URLResponse?, Error?)
    }
    
    /// url请求加工器集合
    private var processors = [Processor]()
    /// 响应内容验证器集合
    private var validators = [Validator]()
    /// 监听器集合
    private var monitors = [Monitor]()
    
    /// 请求执行器
    fileprivate let executor: ExecutorType
    
    /// 构造引擎实例
    ///
    /// - Parameter executor: 请求执行器
    public init(executor: ExecutorType) {
        self.executor = executor
    }
    
    /// 注册url请求加工器
    ///
    /// - Parameter processor: url请求加工器
    open func registerProcessor(processor: @escaping Processor) {
        processors.append(processor)
    }
    
    /// 注册响应内容验证器
    ///
    /// - Parameter validator: 响应内容验证器
    open func registerValidator(validator: @escaping Validator) {
        validators.append(validator)
    }
    
    /// 注册监听器
    ///
    /// - Parameter monitor: 监听器
    open func registerMonitor(monitor: @escaping Monitor) {
        monitors.append(monitor)
    }
    
    /// 对url请求进行加工
    ///
    /// - Parameter urlRequest: url请求
    /// - Returns: 加工后的url请没地方
    open func process(_ urlRequest: URLRequest) throws -> URLRequest {
        return try processors.reduce(urlRequest){ try $1($0) }

    }
    
    /// 验证响应结果
    ///
    /// - Parameters:
    ///   - request:    url请求对象
    ///   - response:   响应对象
    ///   - data:       返回的数据
    /// - Throws: 验证失败将抛出相应的错误
    open func validate(request: URLRequest, response: HTTPURLResponse, data: Data) throws {
        try validators.forEach { try $0(request, response, data) }
    }
    
    /// 执行请求之前
    ///
    /// - Parameter urlRequest: 准备执行的请求对象
    open func onPreRequest(urlRequest: URLRequest) {
        monitors.forEach { $0(.preRequest(urlRequest)) }
    }
    
    /// 执行请求之后
    ///
    /// - Parameter urlRequest: 执行的请求对象
    open func onPostRequest(urlRequest: URLRequest) {
        monitors.forEach { $0(.postRequest(urlRequest)) }
    }
    
    /// 请求返回响应
    ///
    /// - Parameters:
    ///   - data:       数据
    ///   - response:   响应对象
    ///   - error:      错误信息
    open func onResponse(data: Data?, response: URLResponse?, error: Error?) {
        monitors.forEach { $0(.onResponse(data, response, error)) }
    }
}

extension DefaultEngine: EngineType {
    public func call<Request: RequestType, Parser: ParserType>(_ request: Request, with parameter: Request.Parameter, parsedBy parser: Parser, completionHandler: @escaping (APIResult<Parser.Content>) -> Void) -> Cancelable {
        let urlRequest: URLRequest
        do {
            urlRequest = try self.process(request.generateURLRequest(with: parameter))
        } catch {
            completionHandler(.failure(error))
            return NopCancelable.instance
        }
        
        let multipartFormData: MultipartFormData? = request.buildMultipartFormData(with: parameter)
        
        self.onPreRequest(urlRequest: urlRequest)
        defer { self.onPostRequest(urlRequest: urlRequest) }
        
        var canceled = false
        let cancelable = self.executor.execute(urlRequest: urlRequest, multipartFormData: multipartFormData) { data, response, error in
            if canceled { return }
            
            self.onResponse(data: data, response: response, error: error)
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(APIError.responseIsNil))
                return
            }
            
            DispatchQueue.global(qos: .utility).async {
                if canceled { return }
                
                let result: APIResult<Parser.Content>
                do {
                    let content = try parser.parse(data, response: response)
                    result = .success(content)
                } catch {
                    result = .failure(error)
                }
                DispatchQueue.main.async {
                    if canceled { return }
                    completionHandler(result)
                }
            }
        }
        return AnonymousCancelable {
            canceled = true
            cancelable.cancel()
        }
    }
}
