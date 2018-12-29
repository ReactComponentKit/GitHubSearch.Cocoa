//
//  MainSplitViewController.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 27..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
class SearchViewController: NSSplitViewController {
    
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSplitViewItem(NSSplitViewItem(viewController: SearchHistoryViewController(token: viewModel.token)))
        self.addSplitViewItem(NSSplitViewItem(viewController: SearchResultViewController(token: viewModel.token)))
        viewModel.dispatch(action: InitAction())
    }
}
