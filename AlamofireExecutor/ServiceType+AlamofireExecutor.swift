
import Foundation
import LSAPI
extension ServiceType {
    /// 调用接口
    ///
    /// - Parameters:
    ///   - parameter: 参数
    ///   - completionHandler: 回调函数
    /// - Returns: 用于取消请求的句柄
    public func call(with parameter: Parameter, completionHandler: @escaping (APIResult<Content>) -> Void) -> Cancelable {
        return self.call(with: parameter, use: DefaultEngine.alamofireEngine, completionHandler: completionHandler)
    }
}

extension DefaultEngine {
    public static let alamofireEngine: DefaultEngine = DefaultEngine(executor: AlamofireExecutor.instance)
}
