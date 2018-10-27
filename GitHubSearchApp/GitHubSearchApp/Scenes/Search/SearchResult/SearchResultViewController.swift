//
//  SearchResultViewController.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 22..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import CocoaReactComponentKit
import BKRedux
import SnapKit

class SearchResultViewController: NSViewControllerComponent {
    
    private lazy var helloComponent: HelloViewControllerComponent = {
        return HelloViewControllerComponent(token: self.token, canOnlyDispatchAction: true)
    }()
    
    private lazy var emptyComponent: EmptyViewControllerComponent = {
        return EmptyViewControllerComponent(token: self.token, canOnlyDispatchAction: true)
    }()
    
    private lazy var errorComponent: ErrorViewControllerComponent = {
        return ErrorViewControllerComponent(token: self.token, canOnlyDispatchAction: true)
    }()
    
    private lazy var loadingComponent: LoadingViewControllerComponent = {
        return LoadingViewControllerComponent(token: self.token, canOnlyDispatchAction: true)
    }()

    private lazy var collectionViewComponent: NSCollectionViewComponent = {
        let component = NSCollectionViewComponent(token: self.token, canOnlyDispatchAction: true)
        return component
    }()
    
    private lazy var adapter: NSCollectionViewAdapter = {
        let adapter = NSCollectionViewAdapter(collectionViewComponent: collectionViewComponent, useDiff: true)
        return adapter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    private func setupComponents() {
        view.addSubview(collectionViewComponent)
        collectionViewComponent.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionViewComponent.register(component: UserItemComponent.self)
        collectionViewComponent.register(component: RepoItemComponent.self)
        collectionViewComponent.register(component: LoadMoreComponent.self)
        collectionViewComponent.adapter = adapter        
    }
    
    private func handle(state: SearchState) {
        
        helloComponent.removeFromSuperViewController()
        emptyComponent.removeFromSuperViewController()
        loadingComponent.removeFromSuperViewController()
        errorComponent.removeFromSuperViewController()
        collectionViewComponent.isHidden = true
        
        switch state.viewState {
        case .hello:
            self.add(viewController: helloComponent, aboveSubview: collectionViewComponent)
        case .empty:
            self.add(viewController: emptyComponent, aboveSubview: collectionViewComponent)
        case .loading:
            self.add(viewController: loadingComponent, aboveSubview: collectionViewComponent)
        case .loadingIncicator:
            self.add(viewController: loadingComponent, aboveSubview: collectionViewComponent)
        case .list:
            collectionViewComponent.isHidden = false
            self.adapter.set(sections: state.sections)
        case .error(let action):
            errorComponent.retryAction = action
            self.add(viewController: errorComponent, aboveSubview: collectionViewComponent)
        }
    }
    
    override func on(state: State) {
        guard let searchState = state as? SearchState else { return }
        handle(state: searchState)
    }
}
