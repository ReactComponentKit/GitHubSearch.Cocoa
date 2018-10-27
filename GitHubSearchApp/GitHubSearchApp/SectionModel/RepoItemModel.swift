//
//  RepoItemModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import CocoaReactComponentKit

struct RepoItemModel: ItemModel {
    
    var id: Int {
        return repo.id
    }
    
    var componentClass: NSViewComponent.Type {
        return RepoItemComponent.self
    }
    
    func contentSize(in view: NSView) -> CGSize {
        return .zero
    }

    let repo: Repo
    
    init(repo: Repo) {
        self.repo = repo
    }
    
}
