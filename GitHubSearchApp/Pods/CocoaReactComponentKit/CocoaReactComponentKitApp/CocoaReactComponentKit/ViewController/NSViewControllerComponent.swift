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
    
    public var newStateEventBus: EventBus<ComponentNewStateEvent>?
    public var dispatchEventBus: EventBus<ComponentDispatchEvent>
    
    private let usingRootView: Bool
    private lazy var rootView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
        return view
    }()
    
    public var token: Token
    
    public static func viewControllerComponent(identifier: String, storyboard: NSStoryboard) -> NSViewControllerComponent {
        return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(identifier)) as! NSViewControllerComponent
    }
        
    public required init(token: Token, receiveState: Bool = true) {
        self.usingRootView = true
        self.token = token
        dispatchEventBus = EventBus(token: token)
        if receiveState == true {
            newStateEventBus = EventBus(token: token)
        }
        super.init(nibName: nil, bundle: nil)
        newStateEventBus?.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.usingRootView = false
        self.token = Token.empty
        dispatchEventBus = EventBus(token: Token.empty)
        newStateEventBus = nil
        super.init(coder: aDecoder)
    }
    
    // Used for nib view controller
    public func reset(token: Token, receiveState: Bool = true) {
        guard token != Token.empty else { return }
        self.token = token
        self.dispatchEventBus = EventBus(token: token)
        if receiveState == true {
            self.newStateEventBus = EventBus(token: token)
        }
        newStateEventBus?.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            }
        }
    }
    
    open override func loadView() {
        if usingRootView {
            self.view = rootView
        } else {
            super.loadView()
        }
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
