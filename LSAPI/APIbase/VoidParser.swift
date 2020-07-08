
import Foundation

/// 空解析器
public struct VoidParser: ParserType {
    public static let instance = VoidParser()
    
    public typealias Content = Void
    
    private init() {
    }
    
    public func parse(_ data: Data?, response: HTTPURLResponse) throws -> Content {
    }
}
