//
//  ContentView.swift
//  LS_Demo
//
//  Created by sai on 2020/7/9.
//  Copyright © 2020 sai.api.framework. All rights reserved.
//

import SwiftUI
import Combine
import LSAPI

//MARK: Networking with Combine
struct ContentView: View {
    @State private var cancellable: AnyCancellable? = nil
    @State private var cancellableSet: Set<AnyCancellable> = []
    
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                
                self.cancellable = BookService().asPublisher()
                    .sink(receiveCompletion: { (completion) in
                        
                    }) { (result) in
                        print(result)
                }
                //      .store(in: &self.cancellableSet)
                
                // Cancel the activity
                self.cancellable?.cancel()
                
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: Networking with RxSwift
import RxSwift
class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BookService().asObservable()
        .subscribe(onNext: { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        })
        .disposed(by: self.disposeBag)
    }
}
