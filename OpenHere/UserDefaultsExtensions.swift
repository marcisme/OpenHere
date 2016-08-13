//
//  UserDefaultsExtensions.swift
//  OpenHere
//
//  Created by Marc Schwieterman on 8/6/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

import Foundation

extension UserDefaults {

    private static let activateInNewWindowKey = "activateInNewWindow"
    private static let activateInExistingWindowKey = "activateInExistingWindow"
    private static let targetBrowserBundleIdentifierKey = "targetBrowserBundleIdentifier"

    private static let defaultValues = [
        activateInNewWindowKey: true,
        activateInExistingWindowKey: false
    ]

    var activateInNewWindow: Bool {
        return bool(forKey: self.dynamicType.activateInNewWindowKey)
    }

    var activateInExistingWindow: Bool {
        return bool(forKey: self.dynamicType.activateInExistingWindowKey)
    }

    var targetBrowserBundleIdentifier: String? {
        get {
            return string(forKey: self.dynamicType.targetBrowserBundleIdentifierKey)
        }
        set {
            set(newValue, forKey: self.dynamicType.targetBrowserBundleIdentifierKey)
            synchronize()
        }
    }

    func registerDefaultVales() {
        register(defaults: self.dynamicType.defaultValues)
    }
    
}
  
