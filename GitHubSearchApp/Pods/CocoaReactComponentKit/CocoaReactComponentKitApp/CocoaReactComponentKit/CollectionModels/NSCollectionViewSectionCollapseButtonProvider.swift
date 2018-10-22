//
//  NSCollectionViewSectionCollapseButtonProvider.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 21..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa

public protocol NSCollectionViewSectionCollapseButtonProvider {
    var sectionCollapseButton: NSButton? { get set }
}

extension NSCollectionViewSectionCollapseButtonProvider {
    public var sectionCollapseButton: NSButton? {
        return nil
    }
}
