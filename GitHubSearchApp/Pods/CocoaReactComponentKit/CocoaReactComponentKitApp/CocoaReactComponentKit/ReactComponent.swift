//
//  ReactComponent.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 20..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus
import BKRedux
import Cocoa

public enum ComponentNewStateEvent: EventType {
    case on(state: State)
}

public enum ComponentDispatchEvent: EventType {
    case dispatch(action: Action)
}

// Component that can listen to events & dispatch actions
public protocol ReactComponent {
    var token: Token { get set }
    // ReactComponent only has newStateEventBus if it wants to receive the new state.
    // If ReactComponent is in UITableView's cell or UICollectionView's cell,
    // it doesn't receive the new state via newStateEventBus for the performance reason.
    // If every cell component receive the new state via event bus, there are many copying state.
    var newStateEventBus: EventBus<ComponentNewStateEvent>? { get }
    // ReactComponent always has dispatchEventBus for dispatching actions.
    var dispatchEventBus: EventBus<ComponentDispatchEvent> { get }
    init(token: Token, receiveState: Bool)
}

// Component's content size provider
public protocol ContentSizeProvider {
    func contentSize(in view: NSView) -> CGSize
}

