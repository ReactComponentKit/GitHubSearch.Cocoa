//
//  ErrorViewControllerComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import CocoaReactComponentKit
import BKRedux
import RxSwift
import RxCocoa

class ErrorViewControllerComponent: NSViewControllerComponent {

    private let disposeBag = DisposeBag()
    
    private lazy var imageView: NSImageView = {
        let view = NSImageView(frame: .zero)
        view.image = NSImage(named: "ironcat")
        return view
    }()
    
    private lazy var label: NSTextField = {
        let view = NSTextField(frame: .zero)
        view.font = NSFont.boldSystemFont(ofSize: 19)
        view.textColor = NSColor.black
        view.stringValue = "Oops!!!"
        view.isEditable = false
        view.isBordered = false
        return view
    }()
    
    private lazy var retryButton: NSButton = {
        let button = NSButton(frame: .zero)
        button.title = "Retry"
        button.bezelStyle = .roundRect
        return button
    }()
    
    public var retryAction: Action? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(retryButton)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        retryButton.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        if let retryAction = retryAction {
            retryButton.rx.tap.map { retryAction }.bind(onNext: dispatch(action:)).disposed(by: disposeBag)
        }
    }
}
