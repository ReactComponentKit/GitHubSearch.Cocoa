//
//  NSCollectionViewItemLifecycleProvider.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol NSCollectionViewItemLifeCycleProvider {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillLayout()
    func viewDidLayout()
    func viewWillDisappear()
    func viewDidDisappear()
    func viewWillTransition(to newSize: NSSize)
}

// Default Implementation
extension NSCollectionViewItemLifeCycleProvider {
    public func viewDidLoad() {
        
    }
    public func viewWillAppear() {
        
    }
    public func viewDidAppear() {
        
    }
    public func viewWillLayout() {
        
    }
    public func viewDidLayout() {
        
    }
    public func viewWillDisappear() {
        
    }
    public func viewDidDisappear() {
        
    }
    public func viewWillTransition(to newSize: NSSize) {
        
    }
}
