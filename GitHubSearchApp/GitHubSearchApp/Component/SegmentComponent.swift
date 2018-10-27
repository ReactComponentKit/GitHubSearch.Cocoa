//
//  SegmentComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 22..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import CocoaReactComponentKit
import BKEventBus
import SnapKit
import RxSwift
import RxCocoa

class SegmentComponent: NSViewComponent {

    typealias ComponentEvent = (Int) -> Swift.Void
    
    private let disposeBag = DisposeBag()
    private var labels: [String] = []
    private var segmentedControl: NSSegmentedControl? = nil
    
    public var changedSelectedSegment: ComponentEvent? = nil
    
    convenience init(token: Token, labels: [String]) {
        self.init(token: token, canOnlyDispatchAction: true)
        self.labels = labels
        setupView()
    }
    
    required init(token: Token, canOnlyDispatchAction: Bool) {
        super.init(token: token, canOnlyDispatchAction: canOnlyDispatchAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        guard labels.isEmpty == false else { return }
        
        let newSegmentControl = NSSegmentedControl(labels: labels, trackingMode: .selectOne, target: nil, action: nil)
        newSegmentControl.selectedSegment = 0
        newSegmentControl.segmentStyle = .capsule
        addSubview(newSegmentControl)
        newSegmentControl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        newSegmentControl
            .rx
            .controlEvent
            .subscribe(onNext: { [weak self] in
                guard let selectedSegment = self?.segmentedControl?.selectedSegment else { return }
                self?.changedSelectedSegment?(selectedSegment)
            })
            .disposed(by: disposeBag)
        
        self.segmentedControl = newSegmentControl
    }
}
