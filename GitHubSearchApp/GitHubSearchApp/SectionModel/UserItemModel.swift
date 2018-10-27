//
//  UserItem.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import CocoaReactComponentKit

struct UserItemModel: ItemModel {
    var id: Int {
        return user.id
    }
    
    var componentClass: NSViewComponent.Type {
        return UserItemComponent.self
    }
    
    func contentSize(in view: NSView) -> CGSize {
        let width = max(400, view.bounds.width / 3)
        let height = width * 0.4
        return CGSize(width: width - 16, height: height)
    }

    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
}
