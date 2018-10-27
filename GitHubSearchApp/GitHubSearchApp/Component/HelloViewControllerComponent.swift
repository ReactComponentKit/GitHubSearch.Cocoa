//
//  HelloViewControllerComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import CocoaReactComponentKit

class HelloViewControllerComponent: NSViewControllerComponent {
    
    private lazy var imageView: NSImageView = {
        let view = NSImageView(frame: .zero)
        view.image = NSImage(named: "octocat")
        return view
    }()
    
    private lazy var label: NSTextField = {
        let view = NSTextField(frame: .zero)
        view.font = NSFont.boldSystemFont(ofSize: 19)
        view.textColor = NSColor.black
        view.stringValue = "Let's Search!"
        view.isEditable = false
        view.isBordered = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        label.sizeToFit()
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
}
