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

    private let supportedBrowserBundleIdentifiers = [
        "com.apple.SafariTechnologyPreview",
        "com.apple.Safari",
        "com.google.Chrome"
    ]

    func applicationWillFinishLaunching(_ notification: Notification) {
        defaults.registerDefaultVales()
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleGetURLEvent(event:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL))
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let override = true
        if override || notification.userInfo?[NSApplicationLaunchIsDefaultLaunchKey] as? Int == 1 {
            let defaultBundleIdentifier = defaultBrowserBundleIdentifier()
            supportedBrowserBundleIdentifiers.forEach { bundleIdentifier in
                addBrowser(bundleIdentifier: bundleIdentifier, toPopUpButton: browserPopUpButton, withDefaultBundleIdentifier: defaultBundleIdentifier)
            }
            window.makeKeyAndOrderFront(self)
        }
    }

    private func addBrowser(bundleIdentifier: String, toPopUpButton: NSPopUpButton, withDefaultBundleIdentifier defaultBundleIdentifier: String) {
        if let applicationURL = NSWorkspace.shared().urlForApplication(withBundleIdentifier: bundleIdentifier) {
            let resourceValues = try! applicationURL.resourceValues(forKeys: [.effectiveIconKey, .nameKey])
            let title = resourceValues.name!
            let image = resourceValues.effectiveIcon as! NSImage
            let height = browserPopUpButton.fittingSize.height
            image.size = NSSize(width: height, height: height)

            browserPopUpButton.addItem(withTitle: title)
            let item = browserPopUpButton.lastItem!
            item.image = image

            if bundleIdentifier == defaultBundleIdentifier {
                browserPopUpButton.select(item)
            }
        }
    }

    private func defaultBrowserBundleIdentifier() -> String {
        let url = NSWorkspace.shared().urlForApplication(toOpen: URL(string: "http:")!)!
        let bundle = Bundle(url: url)!
        return bundle.bundleIdentifier!
    }

    @IBAction func setDefaultBrowser(_ sender: NSButton) {
        LSSetDefaultHandlerForURLScheme("http", Bundle.main.bundleIdentifier!)
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
