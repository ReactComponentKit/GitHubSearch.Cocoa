//
//  SetKeyword.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import RxSwift
import BKRedux

extension SearchView {
    static func setKeyword(state: State, action: Action) -> Observable<State> {
        guard var mutableState = state as? SearchState else { return .just(state) }
    
        switch action {
        case let act as SearchUsersAction:
            mutableState.keyword = act.keyword
            if act.keyword.isEmpty == false && mutableState.keywordHistory.contains(act.keyword) == false {
                mutableState.keywordHistory.insert(act.keyword, at: 0)
            }
        case let act as SearchReposAction:
            mutableState.keyword = act.keyword
            if act.keyword.isEmpty == false && mutableState.keywordHistory.contains(act.keyword) == false {
                mutableState.keywordHistory.insert(act.keyword, at: 0)
            }
        default:
            break
        }
        
        return .just(mutableState)
    }
}
