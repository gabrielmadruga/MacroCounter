//
//  UserDefaults+Extensions.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/24/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit


private extension String {
    static let userDefaultsKeyPrefix = "preferences."    
    static let userInterfaceStyleKeySuffix = userDefaultsKeyPrefix + "userInterfaceStyle"
}

extension UserDefaults {
    
    
    var userInterfaceStyle: UIUserInterfaceStyle? {
        set {
            guard let newUserInterfaceStyle = newValue else {
                return
            }
            set(newUserInterfaceStyle.rawValue, forKey: .userInterfaceStyleKeySuffix)
            self.synchronize()
        }
        get {
            return UIUserInterfaceStyle(rawValue: integer(forKey: .userInterfaceStyleKeySuffix))
        }
    }
    
    func clear() {
        if let bundle = Bundle.main.bundleIdentifier {
            self.removePersistentDomain(forName: bundle)
        }
    }
}
