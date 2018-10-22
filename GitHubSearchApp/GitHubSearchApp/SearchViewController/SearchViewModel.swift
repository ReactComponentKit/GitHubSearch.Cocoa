//
//  SearchViewModel.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 22..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import CocoaReactComponentKit
import BKRedux

struct SearchViewState: State {
    var searchKeyword: String? = nil
    var searchKeyowrdHistory: [String] = []
    var error: (Error, Action)? = nil
}

class SearchViewModel: RootViewModelType<SearchViewState> {
    
}
