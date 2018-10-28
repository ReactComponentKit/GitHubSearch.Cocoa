//
//  AppDelegate.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 22..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import BKEventBus

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    enum Event: EventType {
        case willFinishLaunching(notification: Notification)
        case didFinishLaunchingWithOptions(notification: Notification)
        case willTerminate(notification: Notification)
    }
    
    private let eventBus = EventBus<AppDelegate.Event>()
    private let appDelegateLogHandler = AppDelegateLogHandler()
    private let appDelegateRequiredValueChecker = AppDelegateRequiredValueChecker()
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        eventBus.post(event: .willFinishLaunching(notification: notification))
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        eventBus.post(event: .didFinishLaunchingWithOptions(notification: aNotification))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        eventBus.post(event: .willTerminate(notification: aNotification))
    }
}

