//
//  Repository.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import Foundation

protocol Repository {
    
    func create(entry: inout Entry)
    func readEntries() -> [Entry]
    func readEntries(day: Date) -> [Entry]
    func update(entry: Entry)
    func delete(entry: inout Entry)
    
    func create(settings: inout Settings)
    func readSettings() -> Settings
    func update(settings: Settings)
    func delete(settings: inout Settings)
    
}
