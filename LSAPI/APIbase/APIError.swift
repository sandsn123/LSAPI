
import Foundation

/// 错误类型
///
/// - responseIsNull: 响应对象为`nil`
/// - dataIsNull: 响应内容为`nil`
/// - parseFailure: 解析失败
/// - canceled: 取消
public enum APIError: Error {
    case responseIsNil
    case dataIsNil
    case parseFailure(String)
    case canceled
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .responseIsNil: return "响应内容为空"
        case .dataIsNil: return "响应内容为空"
        case .canceled: return "请求已取消"
        case .parseFailure(let msg): return msg
        }
    }
}
