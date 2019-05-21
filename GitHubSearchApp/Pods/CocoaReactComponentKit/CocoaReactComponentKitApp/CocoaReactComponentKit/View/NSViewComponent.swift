//
//  NSViewComponent.swift
//  CocoaReactComponentKit
//
//  Created by burt on 2018. 10. 20..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import BKEventBus
import BKRedux

open class NSViewComponent: NSView, ReactComponent, ContentSizeProvider {
    public var token: Token
    public var newStateEventBus: EventBus<ComponentNewStateEvent>? = nil
    public var dispatchEventBus: EventBus<ComponentDispatchEvent>
    
    private var objectsInNib: NSArray?  // retain nib objects
    private weak var nibContentView: NSView? = nil
    public var contentView: NSView {
        return nibContentView ?? self
    }
    
    open func contentSize(in view: NSView) -> CGSize {
        return .zero
    }
        
    public required init(token: Token, receiveState: Bool = true) {
        self.token = token
        self.dispatchEventBus = EventBus(token: token)
        if receiveState == true {
            self.newStateEventBus = EventBus(token: token)
        }
        super.init(frame: .zero)
        self.newStateEventBus?.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            }
        }
        self.wantsLayer = true
        self.setupView()
        invalidateIntrinsicContentSize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.token = Token.empty
        self.dispatchEventBus = EventBus(token: Token.empty)
        super.init(coder: aDecoder)
        loadNibView()
    }
    
    // Used for nib view component
    public func reset(token: Token, receiveState: Bool = true) {
        guard token != Token.empty else { return }
        self.token = token
        self.dispatchEventBus = EventBus(token: token)
        if receiveState == true {
            self.newStateEventBus = EventBus(token: token)
        }
        self.newStateEventBus?.on { [weak self] (event) in
            guard let strongSelf = self else { return }
            switch event {
            case let .on(state):
                strongSelf.applyNew(state: state)
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.wantsLayer = true
        setupView()
        invalidateIntrinsicContentSize()
    }
    
    private func loadNibView() {
        guard let nib = NSNib(nibNamed: NSNib.Name(self.classNameString), bundle: Bundle(for: type(of: self))) else { return }
        guard nib.instantiate(withOwner: self, topLevelObjects: &objectsInNib) == true else { return }
        let rootView = objectsInNib?.first(where: { (obj) -> Bool in
            return obj is NSView
        })
        guard let v = rootView as? NSView else { return }
        addSubview(v)
        nibContentView = v
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            v.topAnchor.constraint(equalTo: self.topAnchor),
            v.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // Override it to layout sub views.
    open func setupView() {
        
    }
    
    // It is only called when the component is in NSTableView's cell or NSCollectionView's cell.
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // It is called when the component is standalone.
    func applyNew(state: State) {
        on(state: state)
        invalidateIntrinsicContentSize()
    }
    
    // Override it to configure or update views
    open func on(state: State) {
        
    }
    
    // It is only called when the component is in NSTableView's cell or NSCollectionView's cell
    func applyNew<Item>(item: Item, at indexPath: IndexPath) {
        configure(item: item, at: indexPath)
        invalidateIntrinsicContentSize()
    }
    
    // Override it to configure or update views
    open func configure<Item>(item: Item, at indexPath: IndexPath) {
        
    }
    
    // Use it to dispatch actions
    public func dispatch(action: Action) {
        dispatchEventBus.post(event: .dispatch(action: action))
    }    
}

extension NSObject {
    @objc fileprivate class var classNameString: String {
        let cname = NSStringFromClass(self)
        if cname.contains(".") {
            let components = cname.components(separatedBy: ".")
            if let last = components.last {
                return last
            }
        }
        return cname
    }
    
    @objc fileprivate var classNameString: String {
        return type(of: self).classNameString
    }
}
