//
//  CollectionViewComponentCell.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 20..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa

// Used for cell, header and footer
internal class CollectionViewComponentItem: NSCollectionViewItem {
    
    var rootComponentView: NSViewComponent?
    var backgroundColor: NSColor = .white {
        didSet {
            self.view.layer?.backgroundColor = backgroundColor.cgColor
        }
    }
    
    override func loadView() {
        guard let rootComponentView = rootComponentView else { return }
        self.view = rootComponentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        guard let v = rootComponentView as? NSCollectionViewItemLifeCycleProvider else { return }
        v.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        guard let v = rootComponentView as? NSCollectionViewItemLifeCycleProvider else { return }
        v.viewWillAppear()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        guard let v = rootComponentView as? NSCollectionViewItemLifeCycleProvider else { return }
        v.viewDidAppear()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        guard let v = rootComponentView as? NSCollectionViewItemLifeCycleProvider else { return }
        v.viewWillLayout()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        guard let v = rootComponentView as? NSCollectionViewItemLifeCycleProvider else { return }
        v.viewDidLayout()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        guard let v = rootComponentView as? NSCollectionViewItemLifeCycleProvider else { return }
        v.viewWillDisappear()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        guard let v = rootComponentView as? NSCollectionViewItemLifeCycleProvider else { return }
        v.viewDidDisappear()
    }
    
    override func viewWillTransition(to newSize: NSSize) {
        super.viewWillTransition(to: newSize)
        guard let v = rootComponentView as? NSCollectionViewItemLifeCycleProvider else { return }
        v.viewWillTransition(to: newSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rootComponentView?.prepareForReuse()
    }
        
}

