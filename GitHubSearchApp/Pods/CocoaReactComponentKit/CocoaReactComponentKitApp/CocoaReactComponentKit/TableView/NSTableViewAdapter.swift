//
//  NSTableViewAdapter.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa

open class NSTableViewAdapter: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    weak private(set) var tableViewComponent: NSTableViewComponent? = nil
    private var section: SectionModel? = nil
    private let useDiff: Bool
    private let componentItemTag = Int.max - 1
    public init(tableViewComponent: NSTableViewComponent?, useDiff: Bool = false) {
        self.tableViewComponent = tableViewComponent
        self.useDiff = useDiff
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        guard let section = section else { return 0 }
        return section.itemCount
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let section = section, row < section.itemCount else { return nil }
        let itemModel = section.items[row]
        let identifier = NSUserInterfaceItemIdentifier(rawValue: String(describing: itemModel.componentClass))
        guard let view = tableView.makeView(withIdentifier: identifier, owner: self) else { return nil }
        guard let token = tableViewComponent?.token else { return nil }

        var rootView: NSViewComponent?
        let componentView = view.subviews.first{ $0.tag == TableViewComponentItem.TAG }
        if let componentItem = componentView as? TableViewComponentItem {
            if let rootComponentView = componentItem.rootComponentView {
                rootView = rootComponentView
            }
        } else {
            rootView = itemModel.componentClass.init(token: token, receiveState: false)
            let componentItem = TableViewComponentItem()
            componentItem.rootComponentView = rootView
            componentItem.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(componentItem)
            NSLayoutConstraint.activate([
                componentItem.topAnchor.constraint(equalTo: view.topAnchor),
                componentItem.leftAnchor.constraint(equalTo: view.leftAnchor),
                componentItem.rightAnchor.constraint(equalTo: view.rightAnchor),
                componentItem.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        let indexPath = IndexPath(item: row, section: 0)
        rootView?.prepareForReuse()
        rootView?.applyNew(item: itemModel, at: indexPath)
        
        return view
    }
    
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        guard let section = section, row < section.itemCount else { return 0 }
        let itemModel = section.items[row]
        return itemModel.contentSize(in: tableView).height
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return tableViewComponent?.shouldSelectRow ?? false
    }
    
    open func set(section: SectionModel) {
        if useDiff == false || self.section == nil {
            self.section = section
            self.tableViewComponent?.reloadData()
        } else if let oldSection = self.section {
            let oldHashable = oldSection.items.map { $0.id }
            let newHashable = section.items.map { $0.id }
            
            let changes = oldHashable.extendedDiff(newHashable)
            if changes.isEmpty == false {
                self.section = section
                self.tableViewComponent?.tableView.apply(changes)
            }
        }
    }
}
