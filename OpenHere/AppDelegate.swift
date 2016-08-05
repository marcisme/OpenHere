//
//  AppDelegate.swift
//  OpenHere
//
//  Created by Marc Schwieterman on 7/30/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

import Cocoa
import ScriptingBridge

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleGetURLEvent(event:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL))
    }

    private dynamic func handleGetURLEvent(event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor) {
        if let urlAsString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue {
            NSLog("urlAsString: \(urlAsString)")
            if let pid = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.SafariTechnologyPreview").first?.processIdentifier {
                let application = AXUIElementCreateApplication(pid)
                if (application.windows?.first(where: { $0.subrole == "AXStandardWindow" })) != nil {
                    SafariTechnologyPreview.openURL(urlAsString)
                    NSRunningApplication.current().terminate()
                }
            }
        }
    }

}

extension AXUIElement {
    var attributeNames: Array<String>? {
        var attributeNames: NSArray?
        let error = withUnsafeMutablePointer(&attributeNames) { pointer -> AXError in
            AXUIElementCopyAttributeNames(self, UnsafeMutablePointer(pointer))
        }
        if error == .success {
            return attributeNames as? Array<String>
        }
        return .none
    }

    var windows: Array<AXUIElement>? {
        var windows: NSArray?
        let error = withUnsafeMutablePointer(&windows) { pointer -> AXError in
            AXUIElementCopyAttributeValues(self, kAXWindowsAttribute, 0, 10, UnsafeMutablePointer(pointer))
        }
        if error == .success {
            return windows as? Array<AXUIElement>
        }
        return .none
    }

    var role: String? {
        return attributeValue(attributeName: kAXRoleAttribute) as? String
    }

    var subrole: String? {
        return attributeValue(attributeName: kAXSubroleAttribute) as? String
    }

    private func attributeValue(attributeName: String) -> AnyObject? {
        var value: AnyObject?
        let error = withUnsafeMutablePointer(&value) { pointer -> AXError in
            AXUIElementCopyAttributeValue(self, attributeName, UnsafeMutablePointer(pointer))
        }
        if error == .success {
            return value
        }
        return .none
    }
}

//-- Open URLs in the front most Safari window if one exists in the current space,
//-- otherwise create a new window and open the incoming URL there.
//
//on open location aLink
//
//--set aLink to "http://www.google.com"
//set foundVisibleWindow to false
//
//tell application "System Events"
//tell application process "Safari"
//-- This should only find windows in the current space.
//-- Currently all windows will have a role of AXWindow, with windows minimized to the dock
//-- having a subrole of AXDialog and visible windows having a subrole of AXStandardWindow.
//set visibleWindows to windows where subrole is "AXStandardWindow"
//if length of visibleWindows is greater than 0 then
//set foundVisibleWindow to true
//end if
//end tell
//end tell
//
//tell application "Safari"
//if foundVisibleWindow then
//tell front window
//make new tab
//set current tab to last tab
//set URL of the current tab to aLink
//end tell
//else
//make new document
//tell front window
//set URL of the current tab to aLink
//activate
//end tell
//end if
//end tell
//
//end open location
