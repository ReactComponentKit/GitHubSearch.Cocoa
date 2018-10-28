//
//  RrlRequestReducer.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 28..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import RxSwift
import RxCocoa

func makeUrlRequest(state: State, action: Action) -> Observable<State> {
    guard var mutableState = state as? WebViewState, let url = URL(string: mutableState.url) else { return .just(state) }
    mutableState.urlRequest = URLRequest(url: url)
    return .just(mutableState)
}
