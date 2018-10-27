//
//  LoadMoreItemModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import CocoaReactComponentKit

struct LoadMoreItemModel: ItemModel {
    
    var id: Int {
        return "LoadMore".hashValue
    }
    
    var componentClass: NSViewComponent.Type {
        return LoadMoreComponent.self
    }
    
    func contentSize(in view: NSView) -> CGSize {
        let width = view.bounds.width / 3
        let height = width * 0.4
        return CGSize(width: width - 16, height: height)
    }
    
    init() {
    
    }
}
