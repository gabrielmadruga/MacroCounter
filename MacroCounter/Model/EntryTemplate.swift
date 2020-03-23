//
//  EntryTemplate.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/22/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import Foundation

struct EntryTemplate: Codable, Macroable {
    var id: Int?
    
    var name: String
    var macros: Macros
    
    init(name: String, macros: Macros) {
        id = nil
        self.name = name
        self.macros = macros
    }
}
