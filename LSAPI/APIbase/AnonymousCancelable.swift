

import Foundation

/// 匿名的可取消对象
///
/// 在闭包中实现取消时执行的实际逻辑，将其封装成可取消对象
public class AnonymousCancelable: Cancelable {
    private var action: (() -> Void)?
    private let lock = NSRecursiveLock()
    
    public init(action: (() -> Void)?) {
        self.action = action
    }
    
    public func cancel() {
        lock.lock()
        defer { lock.unlock() }
        
        if let action = self.action {
            self.action = nil
            action()
        }
    }
}
