# LSAPI
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Language](https://img.shields.io/badge/swift-5.0-orange.svg)](https://developer.apple.com/swift)


LSAPI is a basic library which is convenient to build network request observer, based on Rxswift or Combine.

### Carthage

To integrate LSAPI into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your Cartfile:

```ogdl
github "sandsn123/LSAPI"
```

**NOTE**: Please ensure that you have the [latest](https://github.com/Carthage/Carthage/releases) Carthage installed.

### :book: Usage
##### :eyes: See also:  
- [:link: iOS Example Project](https://github.com/sandsn123/LSAPI/tree/master/LS_Demo)

### Introduce    
- `LSAPI`: Basic interface service protocol library
- `AlamofireExecutor`: On the basis of LSAPI, it uses alamofire to build the executor instance of request, You can customize other executor.
- `RxService`: Rxswift + Alamofire    

```swift        
	GetBookService().asObservable()       
		.subscribe(onNext: { result in
            switch result {    
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        })
        .disposed(by: self.disposeBag)
```
- `CbService`: Combine + Alamofire

```swift		
	self.cancellable = GetBookService().asPublisher()
          .sink(receiveCompletion: { (completion) in 
                  
            }) { (result) in
               print(result)
           }
        //.store(in: &self.cancellableSet)
                
        // Cancel the activity
        self.cancellable?.cancel()
```

