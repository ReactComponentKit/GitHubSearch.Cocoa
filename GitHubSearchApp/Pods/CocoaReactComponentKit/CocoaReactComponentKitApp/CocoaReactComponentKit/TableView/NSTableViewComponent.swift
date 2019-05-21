//
//  NSTableViewComponent.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa

import BKRedux
import BKEventBus

import RxSwift
import RxCocoa

open class NSTableViewComponent: NSViewComponent {
    
    public var adapter: NSTableViewAdapter? {
        didSet {
            tableView.delegate = adapter
            tableView.dataSource = adapter
            tableView.reloadData()
        }
    }
    
    public lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = true
        return scrollView
    }()
    
    public lazy var tableView: NSTableView = {
        let view = NSTableView(frame: .zero)
        view.rowSizeStyle = .custom
        view.backgroundColor = .clear
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "tableview-column"))
        view.headerView = nil
        column.width = 1
        view.addTableColumn(column)
        return view
    }()
    
    public var shouldSelectRow: Bool = true
    public var selectionHighlightStyle: NSTableView.SelectionHighlightStyle = .regular {
        didSet {
            tableView.selectionHighlightStyle = selectionHighlightStyle
        }
    }
    
    public required init(token: Token, receiveState: Bool = false) {
        super.init(token: token, receiveState: receiveState)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setupView() {
        scrollView.documentView = tableView
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    public func register<NSViewComponentType: NSViewComponent>(component: NSViewComponentType.Type) {
        let cellClass = TableViewComponentItem.self
        let frameworkBundle = Bundle(for: cellClass)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("CocoaReactComponentKit.bundle")
        let resourceBundle = Bundle(url: bundleURL!) ?? frameworkBundle
        let identifier = NSUserInterfaceItemIdentifier(rawValue: String(describing: component))
        let nib = NSNib(nibNamed: NSNib.Name("TableViewComponentItem"), bundle: resourceBundle)
        self.tableView.register(nib, forIdentifier: identifier)
    }
    
    open func reloadData() {
        self.tableView.reloadData()
    }
}
