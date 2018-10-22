//
//  ItemModel.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 20..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus

public protocol ItemModel: NSViewComponentClassProvider, ContentSizeProvider {
    // HashValue for using diff algorithms.
    var id: Int { get }
}
