//
//  TextfieldComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import CocoaReactComponentKit
import SnapKit
import RxSwift
import RxCocoa

class TextfieldComponent: NSViewComponent {
    
    typealias ComponentEvent = (String?) -> Swift.Void
    private let disposeBag = DisposeBag()
    var changedText: ComponentEvent? = nil
    var enterText: ComponentEvent? = nil
    
    private lazy var textfield: NSTextField = {
        let view = NSTextField(frame: .zero)
        view.placeholderString = "Enter search keywords"
        return view
    }()
    
    override func setupView() {
        addSubview(textfield)
        textfield.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        textfield
            .rx
            .text
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (str) in
                self?.changedText?(str)
            })
            .disposed(by: disposeBag)
        
        textfield
            .rx
            .controlEvent
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.changedText?(self?.textfield.stringValue)
            })
            .disposed(by: disposeBag)
        
    }
}
