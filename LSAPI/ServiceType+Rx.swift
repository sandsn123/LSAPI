
import Foundation
import RxSwift
import Combine

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

    @available(iOS 13.0, *)
    func asPublisher(parameter: Parameter) -> AnyPublisher<Content, Error> {
        return
            Deferred {
                Future { (promise) in
                    _ = self.call(with: parameter) { result in
                        promise(result.mapToResult())
                    }
                }
            }
            .eraseToAnyPublisher()
        
    }
}

public extension ServiceType where Parameter == Void {
    func asObservable() -> Observable<APIResult<Content>> {
        return self.asObservable(parameter: ())
    }

    @available(iOS 13.0, *)
    func asPublisher() -> AnyPublisher<Content, Error> {
        return self.asPublisher(parameter: ())
    }
}

public extension Cancelable {
    func asDisposable() -> Disposable {
        return Disposables.create(with: self.cancel)
    }
}

