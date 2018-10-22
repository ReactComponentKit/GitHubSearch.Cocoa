//
//  NSViewComponentClassProvider.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 20..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation

public protocol NSViewComponentClassProvider {
    var componentClass: NSViewComponent.Type { get }
}
