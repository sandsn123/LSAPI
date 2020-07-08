
import Foundation

/// 数据解析器的协议
///
/// 将网络请求返回的数据解析成期望的数据类型
public protocol ParserType {
    associatedtype Content
    
    /// 将数据解析成所期望的数据类型
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - response: 响应对象
    /// - Returns: 所期望数据类型的解析结果
    /// - Throws: 解析可能失败，并抛出相应的解析错误
    func parse(_ data: Data?, response: HTTPURLResponse) throws -> Content
}
