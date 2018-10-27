//
//  NSViewControllerComponent.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 20..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import BKEventBus
import BKRedux

open class NSViewControllerComponent: NSViewController, ReactComponent {
    
    public lazy var newStateEventBus: EventBus<ComponentNewStateEvent>? = {
        EventBus(token: self.token)
    }()
    
    public lazy var dispatchEventBus: EventBus<ComponentDispatchEvent> = {
        EventBus(token: self.token)
    }()
    
    
    private lazy var rootView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
        return view
    }()
    
    public var token: Token
    
    public required init(token: Token, canOnlyDispatchAction: Bool = false) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
        
        newStateEventBus?.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            }
        }
    }
    
    open override func loadView() {
        self.view = rootView
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func applyNew(state: State) {
        on(state: state)
    }
    
    open func on(state: State) {
        
    }
    
    public func dispatch(action: Action) {
        dispatchEventBus.post(event: .dispatch(action: action))
    }
}
