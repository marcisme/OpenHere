//
//  AXUIElementExtensions.swift
//  OpenHere
//
//  Created by Marc Schwieterman on 8/6/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

import Foundation

extension AXUIElement {
    var hasWindowInCurrentSpace: Bool {
        return windows?.first(where: { $0.subrole == "AXStandardWindow" }) != nil
    }

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
