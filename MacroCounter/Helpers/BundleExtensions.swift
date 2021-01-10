//
//  BundleExtensions.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 1/9/21.
//  Copyright © 2021 Gabriel Madruga. All rights reserved.
//

import Foundation

extension Bundle {
    
    var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var build: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    var formattedVersion: String {
        if let version = version, let build = build {
            return "\(version) (\(build))" // Ex. "v4.10.1 (150)"
        } else {
            return "-"
        }
        
    }
}
