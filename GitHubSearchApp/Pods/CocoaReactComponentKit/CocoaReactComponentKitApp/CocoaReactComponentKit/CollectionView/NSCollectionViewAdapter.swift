//
//  NSCollectionViewAdapter.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa

open class NSCollectionViewAdapter: NSObject, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    
    weak private(set) var collectionViewComponent: NSCollectionViewComponent? = nil
    private var sections: [SectionModel] = []
    private let useDiff: Bool
    
    public init(collectionViewComponent: NSCollectionViewComponent?, useDiff: Bool = false) {
        self.collectionViewComponent = collectionViewComponent
        self.useDiff = useDiff
    }
    
    open func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return sections.count
    }
    
    open func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard sections.count > section else { return 0 }
        return sections[section].itemCount
    }
    
    open func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let itemModel = sections[indexPath.section].items[indexPath.item]
        let identifier = NSUserInterfaceItemIdentifier(rawValue: String(describing: itemModel.componentClass))
        let item = collectionView.makeItem(withIdentifier: identifier, for: indexPath)
        
        if let componentItem = item as? CollectionViewComponentItem {
            if let rootComponentView = componentItem.rootComponentView {
                rootComponentView.applyNew(item: itemModel)
            } else {
                if let token = collectionViewComponent?.token {
                    let component = itemModel.componentClass.init(token: token, canOnlyDispatchAction: true)
                    component.applyNew(item: itemModel)
                    componentItem.rootComponentView = component
                }
            }
        }
        
        return item
    }
    
    public func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let section = indexPath.section
        
        if kind == NSCollectionView.elementKindSectionHeader {
            guard let header = sections[section].header else { return NSView(frame: .zero) }
            guard let token = collectionViewComponent?.token else { return NSView(frame: .zero) }
            
            let identifier = NSUserInterfaceItemIdentifier(String(describing: header.componentClass))
            let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: identifier, for: indexPath)
            if let componentView = view as? CollectionSectionHeaderView {
                if let rootComponentView = componentView.rootComponentView {
                    rootComponentView.applyNew(item: header)
                } else {
                    let rootComponentView = header.componentClass.init(token: token, canOnlyDispatchAction: true)
                    rootComponentView.applyNew(item: header)
                    componentView.rootComponentView = rootComponentView
                }
            }
            return view
        } else {
            guard let footer = sections[section].footer else { return NSView(frame: .zero) }
            guard let token = collectionViewComponent?.token else { return NSView(frame: .zero) }
            
            let identifier = NSUserInterfaceItemIdentifier(String(describing: footer.componentClass))
            let view = collectionView.makeSupplementaryView(ofKind: kind, withIdentifier: identifier, for: indexPath)
            if let componentView = view as? CollectionSectionFooterView {
                if let rootComponentView = componentView.rootComponentView {
                    rootComponentView.applyNew(item: footer)
                } else {
                    let rootComponentView = footer.componentClass.init(token: token, canOnlyDispatchAction: true)
                    rootComponentView.applyNew(item: footer)
                    componentView.rootComponentView = rootComponentView
                }
            }
            return view
        }
    }

    open func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        guard sections.count > indexPath.section else { return .zero }
        guard sections[indexPath.section].items.count > indexPath.item else { return .zero }
        let itemModel = sections[indexPath.section].items[indexPath.item]
        return itemModel.contentSize(in: collectionView)
    }
    
    open func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        guard sections.count > section else { return .zero }
        guard let header = sections[section].header else { return .zero }
        return header.contentSize(in: collectionView)
    }
    
    open func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForFooterInSection section: Int) -> NSSize {
        guard sections.count > section else { return .zero }
        guard let footer = sections[section].footer else { return .zero }
        return footer.contentSize(in: collectionView)
    }

    open func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        guard sections.count > section else { return NSEdgeInsetsZero }
        let sectionModel = sections[section]
        return sectionModel.inset
    }

    open func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard sections.count > section else { return 0 }
        let sectionModel = sections[section]
        return sectionModel.minimumLineSpacing
    }
    
    open func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard sections.count > section else { return 0 }
        let sectionModel = sections[section]
        return sectionModel.minimumInteritemSpacing
    }
    
    open func set(section: SectionModel) {
        self.set(sections: [section])
    }
    
    open func set(sections: [SectionModel]) {
        if useDiff == false {
            self.sections = sections
            self.collectionViewComponent?.reloadData()
        } else {
            if self.sections.count != sections.count {
                self.sections = sections
                self.collectionViewComponent?.reloadData()
            } else {
                var section: Int = 0
                let oldSections = self.sections
                zip(oldSections, sections).forEach { (oldSection, newSection) in
                    let oldHashable = oldSection.items.map { $0.id }
                    let newHashable = newSection.items.map { $0.id }
                    
                    let changes = oldHashable.extendedDiff(newHashable)
                    self.sections[section] = newSection
                    self.collectionViewComponent?.collectionView.apply(changes)
                    section += 1
                }
            }
        }
    }
}

