//
//  Settings.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import Foundation

struct Settings: Codable, Macroable {

    var id: Int? = nil
    var macros: Macros
    var goals: Macros {
        get {
            return macros
        }
        set {
            macros = newValue
        }
    }
    
}
