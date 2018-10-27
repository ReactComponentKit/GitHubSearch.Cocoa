//
//  LoadMoreComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import CocoaReactComponentKit

class LoadMoreComponent: NSViewComponent {
    
    private lazy var indicator: NSProgressIndicator = {
        let view = NSProgressIndicator(frame: .zero)
        view.style = .spinning
        return view
    }()
    
    private lazy var loadMoreButton: NSButton = {
        let button = NSButton(title: "Load More", target: self, action: #selector(clickButton))
        button.bezelStyle = NSButton.BezelStyle.rounded
        button.isBordered = false 
        button.font = NSFont.boldSystemFont(ofSize: 34)
        button.alignment = .center
        return button
    }()
    
    override func contentSize(in view: NSView) -> CGSize {
        return .zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override func setupView() {
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        indicator.isHidden = true

        addSubview(loadMoreButton)
        loadMoreButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func configure<Item>(item: Item) {
        reset()
    }
    
    @objc func clickButton(_ sender: Any) {
        loadMoreButton.isHidden = true
        indicator.isHidden = false
        indicator.startAnimation(nil)
        dispatch(action: LoadMoreAction())
    }
    
    private func reset() {
        indicator.stopAnimation(nil)
        indicator.isHidden = true
        loadMoreButton.isHidden = false
    }
}

