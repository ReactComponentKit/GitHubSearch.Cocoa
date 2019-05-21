//
//  WebViewModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 28..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import CocoaReactComponentKit
import BKRedux
import RxSwift
import RxCocoa

struct WebViewState: State {
    var url: String
    var error: (Error, Action)? = nil
    var urlRequest: URLRequest? = nil
    
    init() {
        self.url = ""
    }
    
    init(url: String) {
        self.url = url
    }
}

class WebViewModel: RootViewModelType<WebViewState> {
    
    struct Output {
        let urlRequest = BehaviorRelay<URLRequest?>(value: nil)
        let close = BehaviorRelay<Bool>(value: false)
        fileprivate init() {
        }
    }
    
    lazy var output: Output = {
        return Output()
    }()
    
    let url: String
    init(url: String) {
        self.url = url
        super.init()
        store.set(initialState: WebViewState(url: url),
                  middlewares: [
                    makeUrlRequest
                  ],
                  reducers: [],
                  postwares: [])
    }
    
    override func beforeDispatch(action: Action) -> Action {
        switch action {
        case is CloseWebViewAction:
            output.close.accept(true)
            return VoidAction()
        default:
            break
        }
        return action
    }
    
    override func on(newState: WebViewState) {
        output.urlRequest.accept(newState.urlRequest)
    }
}
