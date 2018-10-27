//
//  MakeSectionModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKRedux
import RxSwift
import CocoaReactComponentKit

extension SearchView {
    static func makeSectionModel(state: State, action: Action) -> Observable<State> {
        guard var mutableState = state as? SearchState else { return .just(state) }
        
        return Single.create(subscribe: { (single) -> Disposable in
            // search result
            let sectionModel: SectionModel
            switch mutableState.searchScope {
            case .user:
                sectionModel = makeUserSectionModel(users: mutableState.users)
                mutableState.canLoadMore = (mutableState.users.count > 0 && mutableState.users.count % mutableState.perPage == 0)
            case .repo:
                sectionModel = makeRepoSectionModel(repos: mutableState.repos)
                mutableState.canLoadMore = (mutableState.repos.count > 0 && mutableState.repos.count % mutableState.perPage == 0)
            }
            
            if mutableState.canLoadMore {
                let loadMoreSectionModel = DefaultSectionModel(items: [])
                mutableState.sections = [sectionModel, loadMoreSectionModel]
            } else {
                mutableState.sections = [sectionModel]
            }
            
            // history
            mutableState.hitorySectons = makeHistorySectionModel(history: mutableState.keywordHistory)
            
            single(.success(mutableState))
            return Disposables.create()
        }).asObservable()
    }
    
    
    private static func makeUserSectionModel(users: [User]) -> SectionModel {
        guard users.isEmpty == false else { return DefaultSectionModel(items: []) }
        var items: [ItemModel] = users.map(UserItemModel.init)
        items.append(LoadMoreItemModel())
        return DefaultSectionModel(items: items)
    }
    
    private static func makeRepoSectionModel(repos: [Repo]) -> SectionModel {
        guard repos.isEmpty == false else { return DefaultSectionModel(items: []) }
        var items: [ItemModel] = repos.map(RepoItemModel.init)
        items.append(LoadMoreItemModel())
        return DefaultSectionModel(items: items)
    }
    
    private static func makeHistorySectionModel(history: [String]) -> SectionModel {
        guard history.isEmpty == false else { return DefaultSectionModel(items: []) }
        let items = history.map(HistoryItemModel.init)
        return DefaultSectionModel(items: items)
    }
}
