//
//  NSViewController+Component.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 20..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import Cocoa

extension NSViewController {
    @discardableResult
    public func add(viewController: NSViewController) -> NSViewController {
        addChild(viewController)
        view.addSubview(viewController.view)
        return viewController
    }
    
    @discardableResult
    public func add(viewController: NSViewController, belowSubview: NSView) -> NSViewController {
        addChild(viewController)
        view.addSubview(viewController.view, positioned: .below, relativeTo: belowSubview)
        return viewController
    }
    
    @discardableResult
    public func add(viewController: NSViewController, aboveSubview: NSView) -> NSViewController {
        addChild(viewController)
        view.addSubview(viewController.view, positioned: .below, relativeTo: aboveSubview)
        return viewController
    }
    
    @discardableResult
    public func add(viewController: NSViewController, outOfSubview: NSView) -> NSViewController {
        addChild(viewController)
        view.addSubview(viewController.view, positioned: .out, relativeTo: outOfSubview)
        return viewController
    }
    
    public func removeFromSuperViewController() {
        guard parent != nil else { return }
        removeFromParent()
        view.removeFromSuperview()
    }
}

