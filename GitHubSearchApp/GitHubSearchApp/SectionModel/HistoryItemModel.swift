//
//  HistoryItemModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 28..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import CocoaReactComponentKit

struct HistoryItemModel: ItemModel {
    var id: Int {
        return keyword.hashValue
    }
    
    var componentClass: NSViewComponent.Type {
        return HistoryItemComponent.self
    }
    
    func contentSize(in view: NSView) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width, height: 40)
    }
    
    let keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
    }
    
}

