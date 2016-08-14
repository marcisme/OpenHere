//
//  BrowserManager.swift
//  OpenHere
//
//  Created by Marc Schwieterman on 8/13/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

import Cocoa

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

    var isDefaultBrowser: Bool {
        return defaultBrowserBundleIdentifier == Bundle.main.bundleIdentifier!
    }

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
