//
//  AppDelegate.swift
//  OpenHere
//
//  Created by Marc Schwieterman on 7/30/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    private let defaults = UserDefaults.standard

    func applicationWillFinishLaunching(_ notification: Notification) {
        defaults.registerDefaultVales()
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleGetURLEvent(event:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL))
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        if notification.userInfo?[NSApplicationLaunchIsDefaultLaunchKey] as? Int == 1 {
            window.makeKeyAndOrderFront(self)
        }
    }

    private dynamic func handleGetURLEvent(event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor) {
        if let urlAsString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue {
            if let pid = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.SafariTechnologyPreview").first?.processIdentifier {
                let application = AXUIElementCreateApplication(pid)
                let newWindow = !application.hasWindowInCurrentSpace
                SafariTechnologyPreview.openURL(
                    urlAsString,
                    inNewWindow: newWindow,
                    activateInNewWindow: defaults.activateInNewWindow,
                    activateInExistingWindow: defaults.activateInExistingWindow)
                NSRunningApplication.current().terminate()
            }
        }
    }

}
