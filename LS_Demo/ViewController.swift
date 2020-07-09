//
//  ViewController.swift
//  LS_Demo
//
//  Created by sai on 2020/7/9.
//  Copyright © 2020 sai.api.framework. All rights reserved.
//

import UIKit
import RxService
import RxSwift

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Networking with RxSwift
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
