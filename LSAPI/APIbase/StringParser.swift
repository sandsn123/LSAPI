
import Foundation

/// 字符串解析器
///
/// 内容为字符串的解析器，将字符串解析成期望的数据类型
public protocol StringParserType: ParserType {
    /// 将字符串内容解析成所期望的数据类型
    ///
    /// - Parameter string: 字符串内容
    /// - Returns: 所期望数据类型的解析结果
    /// - Throws: 解析可能失败，并抛出相应的解析错误
    func parse(_ string: String) throws -> Content
}

public extension StringParserType {
    func parse(_ data: Data?, response: HTTPURLResponse) throws -> Content {
        let encoding: String.Encoding
        if let encodingName = response.textEncodingName {
            let rawValue = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName as CFString?))
            encoding = String.Encoding(rawValue: rawValue)
        } else {
            encoding = String.Encoding.utf8
        }
        
        guard let data = data else {
            throw APIError.dataIsNil
        }
        guard let string = String(data: data, encoding: encoding) else {
            throw APIError.parseFailure("响应内容解析失败")
        }
        
        return try parse(string)
    }
}

public struct StringParser: StringParserType {
    public static let instance = StringParser()
    
    public typealias Content = String
    
    private init() {
    }
    
    public func parse(_ string: String) throws -> Content {
        return string
    }
}
