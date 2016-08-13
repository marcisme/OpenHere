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
        if true || notification.userInfo?[NSApplicationLaunchIsDefaultLaunchKey] as? Int == 1 {
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

struct BrowserDescription {
    let bundleIdentifier: String
    let name: String
    let image: NSImage
    let isTargetBrowser: Bool
}

class BrowserManager {

    lazy var browserDescriptions: [BrowserDescription] = {
        return self.supportedBrowsers.keys.flatMap { bundleIdentifier -> BrowserDescription? in
            guard let applicationURL = NSWorkspace.shared().urlForApplication(withBundleIdentifier: bundleIdentifier) else {
                return nil
            }
            let resourceValues = try! applicationURL.resourceValues(forKeys: [.effectiveIconKey, .nameKey])
            let name = resourceValues.name!
            let image = resourceValues.effectiveIcon as! NSImage
            func isTargetBrowser(_ bundleIdentifier: String) -> Bool {
                if let targetBrowserBundleIdentifier = self.defaults.targetBrowserBundleIdentifier {
                    return bundleIdentifier == targetBrowserBundleIdentifier
                }
                return bundleIdentifier == self.defaultBrowserBundleIdentifier
            }
            return BrowserDescription(bundleIdentifier: bundleIdentifier, name: name, image: image, isTargetBrowser: isTargetBrowser(bundleIdentifier))
        }
    }()

    private struct BrowserBundleIdentifier {
        static let safari = "com.apple.Safari"
        static let safariTechnologyPreview = "com.apple.SafariTechnologyPreview"
        static let chrome = "com.google.Chrome"
    }

    private typealias BBI = BrowserBundleIdentifier

    private let supportedBrowsers: [String:Browser] = [
        BBI.safariTechnologyPreview: Safari(bundleIdentifier: BBI.safariTechnologyPreview),
        BBI.safari: Safari(bundleIdentifier: BBI.safari),
        BBI.chrome: Chrome(bundleIdentifier: BBI.chrome)
    ]

    private lazy var defaultBrowserBundleIdentifier: String = {
        let url = NSWorkspace.shared().urlForApplication(toOpen: URL(string: "http:")!)!
        let bundle = Bundle(url: url)!
        return bundle.bundleIdentifier!
    }()

    private let defaults = UserDefaults.standard

    func setTargetBrowser(index: Int) {
        defaults.targetBrowserBundleIdentifier = Array(supportedBrowsers.keys)[index]
    }

    func openURL(url: String, inNewWindow: Bool) {
        supportedBrowsers[defaults.targetBrowserBundleIdentifier!]?.openURL(url, inNewWindow: inNewWindow, activateInNewWindow: defaults.activateInNewWindow, activateInExistingWindow: defaults.activateInExistingWindow)
    }

}
