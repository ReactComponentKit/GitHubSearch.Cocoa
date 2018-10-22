//
//  TableViewComponentItem.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa

internal class TableViewComponentItem: NSTableCellView {
    
    var rootComponentView: NSViewComponent? {
        didSet {
            guard rootComponentView != nil else { return }
            rootComponentView?.removeFromSuperview()
            installRootComponentView()
        }
    }
    
    static let TAG: Int = (Int.max - 1)
    
    override var tag: Int {
        return TableViewComponentItem.TAG
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rootComponentView?.prepareForReuse()
    }
    
    private func installRootComponentView() {
        guard let rootComponentView = rootComponentView else { return }
        self.addSubview(rootComponentView)
        rootComponentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootComponentView.topAnchor.constraint(equalTo: self.topAnchor),
            rootComponentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rootComponentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            rootComponentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
