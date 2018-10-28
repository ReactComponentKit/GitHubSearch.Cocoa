//
//  AppDelegateLogHandler.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 25..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Foundation
import BKEventBus

class AppDelegateLogHandler: AppDelegateHandler {
    
    var eventBus = EventBus<AppDelegate.Event>()
    
    required init() {
        handle()
    }
    
    func handle() {
        eventBus.on { (event: AppDelegate.Event) in
            switch event {
            case .willFinishLaunching:
                print("Application will finish launching")
            case .didFinishLaunchingWithOptions:
                print("Application did finish launching")
            case .willTerminate:
                print("Application will terminate")
            }
        }
    }
    
    
}
