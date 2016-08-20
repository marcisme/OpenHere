//
//  UserDefaultsExtensions.swift
//  OpenHere
//
//  Created by Marc Schwieterman on 8/6/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

import Foundation

extension UserDefaults {

    private struct Keys {
        static let activateInNewWindow = "activateInNewWindow"
        static let activateInExistingWindow = "activateInExistingWindow"
        static let targetBrowserBundleIdentifier = "targetBrowserBundleIdentifier"
    }

    private static let defaultValues = [
        Keys.activateInNewWindow: true,
        Keys.activateInExistingWindow: false
    ]

    var activateInNewWindow: Bool {
        return bool(forKey: Keys.activateInNewWindow)
    }

    var activateInExistingWindow: Bool {
        return bool(forKey: Keys.activateInExistingWindow)
    }

    var targetBrowserBundleIdentifier: String? {
        get {
            return string(forKey: Keys.targetBrowserBundleIdentifier)
        }
        set {
            set(newValue, forKey: Keys.targetBrowserBundleIdentifier)
            synchronize()
        }
    }

    func registerDefaultVales() {
        register(defaults: type(of: self).defaultValues)
    }
    
}
  
