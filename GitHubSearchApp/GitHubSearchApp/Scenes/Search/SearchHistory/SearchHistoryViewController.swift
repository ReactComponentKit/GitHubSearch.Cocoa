//
//  SearchViewController.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 22..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import SnapKit
import CocoaReactComponentKit
import BKEventBus
import BKRedux

class SearchHistoryViewController: NSViewControllerComponent {
    
    private lazy var textfieldComponent: TextfieldComponent = {
        let component = TextfieldComponent(token: self.token, receiveState: false)
        return component
    }()
    
    private lazy var searchModeComponent: SegmentComponent = {
        let component = SegmentComponent(token: self.token, labels: ["User", "Repo"])
        return component
    }()
    
    private lazy var tableViewComponent: NSTableViewComponent = {
        let component = NSTableViewComponent(token: self.token, receiveState: false)
        component.selectionHighlightStyle = .none
        component.wantsLayer = true
        component.layer?.cornerRadius = 5
        return component
    }()
    
    private lazy var adapter: NSTableViewAdapter = {
        let adapter = NSTableViewAdapter(tableViewComponent: tableViewComponent, useDiff: true)
        return adapter
    }()
    
    required init(token: Token, receiveState: Bool = true) {
        super.init(token: token, receiveState: receiveState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer?.backgroundColor = NSColor.controlColor.cgColor
        view.addSubview(textfieldComponent)
        view.addSubview(searchModeComponent)
        view.addSubview(tableViewComponent)
                
        textfieldComponent.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.greaterThanOrEqualTo(200)
            make.top.equalToSuperview().offset(30)
        }
        
        searchModeComponent.snp.makeConstraints { (make) in
            make.left.right.equalTo(textfieldComponent)
            make.top.equalTo(textfieldComponent.snp.bottom).offset(8)
        }
        
        tableViewComponent.snp.makeConstraints { (make) in
            make.left.right.equalTo(textfieldComponent)
            make.top.equalTo(searchModeComponent.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        // propagate input text
        textfieldComponent.changedText = { [weak self] (keyword) in
            guard let keyword = keyword else { return }
            self?.dispatch(action: InputSearchKeywordAction(keyword: keyword))
        }
        
        textfieldComponent.enterText = { [weak self] keyword in
            guard let keyword = keyword else { return }
            self?.dispatch(action: StoreKeywordAction(keyword: keyword))
        }
        
        searchModeComponent.changedSelectedSegment = { [weak self] (index) in
            let searchScope: SearchState.SearchScope = index == 0 ? .user : .repo
            self?.dispatch(action: SelectSearchScopeAction(searchScope: searchScope))
        }
        
        tableViewComponent.adapter = adapter
        tableViewComponent.register(component: HistoryItemComponent.self)
    }
    
    override func on(state: State) {
        guard let searchState = state as? SearchState, let section = searchState.hitorySectons else { return }
        adapter.set(section: section)
    }
    
}
