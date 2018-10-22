//
//  SearchViewController.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 22..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import SnapKit

class SearchViewController: NSViewController {
    
    private let viewModel = SearchViewModel()
    
    private lazy var searchModeComponent: SegmentComponent = {
        let component = SegmentComponent(token: viewModel.token, labels: ["User", "Repo"])
        return component
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(searchModeComponent)
        searchModeComponent.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(60)
            make.height.equalTo(50)
        }
    }
    
}
