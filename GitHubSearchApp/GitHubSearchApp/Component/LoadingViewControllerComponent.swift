//
//  LoadingViewControllerComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import SnapKit
import CocoaReactComponentKit

class LoadingViewControllerComponent: NSViewControllerComponent {

    private lazy var indicator: NSProgressIndicator = {
        let view = NSProgressIndicator(frame: .zero)
        view.style = .spinning
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        indicator.startAnimation(nil)
    }

}
