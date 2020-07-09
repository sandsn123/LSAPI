
import Foundation
import RxSwift
import LSAPI

public extension ServiceType {
    func asObservable(parameter: Parameter) -> Observable<APIResult<Content>> {
        return Observable.create({ observer in
            let serialDisposable = SerialDisposable()
            let cancelable = self.call(with: parameter) { result in
                if serialDisposable.isDisposed { return }
                observer.onNext(result)
                observer.onCompleted()
            }
            serialDisposable.disposable = cancelable.asDisposable()
            return serialDisposable
        })
    }
}

public extension ServiceType where Parameter == Void {
    func asObservable() -> Observable<APIResult<Content>> {
        return self.asObservable(parameter: ())
    }
}

public extension LSAPI.Cancelable {
    func asDisposable() -> Disposable {
        return Disposables.create {
            self.cancel()
        }
    }
}

