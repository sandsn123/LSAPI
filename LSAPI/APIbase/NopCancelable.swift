

import Foundation

/// 什么都不做的可取消对象
public class NopCancelable: Cancelable {
    public static let instance = NopCancelable()
    
    private init() {}
    
    public func cancel() {}
}
