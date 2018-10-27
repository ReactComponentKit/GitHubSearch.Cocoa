//
//  HistoryComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 28..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import CocoaReactComponentKit
import SnapKit
import RxSwift
import SDWebImage

class HistoryItemComponent: NSViewComponent {
    
    private var htmlUrl: String? = nil
    private let disposeBag = DisposeBag()
    
    private lazy var cardView: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
        return view
    }()
    
    private lazy var clickView: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = .clear
        return view
    }()
    
    private lazy var keywordLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.boldSystemFont(ofSize: 13)
        label.textColor = NSColor.black
        label.alignment = .center
        label.usesSingleLineMode = true
        label.isEditable = false
        label.isBordered = false
        return label
    }()
    
    override func contentSize(in view: NSView) -> CGSize {
        return .zero
    }
    
    override func setupView() {
        addSubview(cardView)
        addSubview(clickView)
        cardView.addSubview(keywordLabel)
        
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        clickView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        keywordLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        clickView.onTap { [weak self] in
            guard let strongSelf = self, let keyword = strongSelf.keyword else { return }
            strongSelf.dispatch(action: InputSearchKeywordAction(keyword: keyword))
        }.disposed(by: disposeBag)
    }
    
    private var keyword: String? = nil
    
    override func configure<Item>(item: Item) {
        guard let historyItem = item as? HistoryItemModel else { return }
        keyword = historyItem.keyword
        keywordLabel.stringValue = historyItem.keyword
    }
}

