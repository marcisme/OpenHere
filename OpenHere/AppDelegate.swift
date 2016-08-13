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
    @IBOutlet weak var browserPopUpButton: NSPopUpButton!

    private let defaults = UserDefaults.standard
    private let browserManager = BrowserManager()

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
            browserManager.browserDescriptions.forEach { browser in
                add(browser: browser, toPopUpButton: browserPopUpButton)
            }
            window.makeKeyAndOrderFront(self)
        }
    }

    private func add(browser: BrowserDescription, toPopUpButton: NSPopUpButton) {
        let image = browser.image
        let height = browserPopUpButton.fittingSize.height
        image.size = NSSize(width: height, height: height)

        browserPopUpButton.addItem(withTitle: browser.name)
        let item = browserPopUpButton.lastItem!
        item.image = image

        if browser.isTargetBrowser {
            browserPopUpButton.select(item)
        }
    }

    @IBAction func browserPopUpButtonChanged(button: NSPopUpButton) {
        setTargetBrowserToSelectedBrowser()
    }

    @IBAction func setDefaultBrowser(_ sender: NSButton) {
        LSSetDefaultHandlerForURLScheme("http", Bundle.main.bundleIdentifier!)
        setTargetBrowserToSelectedBrowser()
    }

    private func setTargetBrowserToSelectedBrowser() {
        browserManager.setTargetBrowser(index: browserPopUpButton.indexOfSelectedItem)
    }

    private dynamic func handleGetURLEvent(event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor) {
        if let urlAsString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue {
            if let pid = NSRunningApplication.runningApplications(withBundleIdentifier: defaults.targetBrowserBundleIdentifier!).first?.processIdentifier {
                let application = AXUIElementCreateApplication(pid)
                let newWindow = !application.hasWindowInCurrentSpace
                browserManager.openURL(url: urlAsString, inNewWindow: newWindow)
                NSRunningApplication.current().terminate()
            }
        }
    }

}
