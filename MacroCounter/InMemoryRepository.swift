//
//  InMemoryRepository.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import Foundation

class InMemoryRepository: Repository {
    
    // MARK: - Entry
    var entries: [Int: Entry] = [:]
    
    func create(entry: inout Entry) {
        if entry.id != nil { fatalError("Can't create entry with repeated id") }
        let id = Array(entries.keys).last ?? 0
        entry.id = id
        entries[id] = entry
    }
    
    func readEntries() -> [Entry] {
        return Array(entries.values)
    }
    
    func readEntries(day: Date) -> [Entry] {
        return entries.values.filter({ (entry) -> Bool in
            Calendar.current.isDate(entry.date, inSameDayAs: day)
        })
    }
    
    func update(entry: Entry) {
        guard let id = entry.id else { fatalError("Can't update entry without id") }
        entries[id] = entry
    }
    
    func delete(entry: inout Entry) {
        guard let id = entry.id else { fatalError("Can't delete entry without id") }
        entry.id = nil
        entries[id] = nil
    }
    
    // MARK: - Settings
    var settings: Settings? = nil
    
    func create(settings: inout Settings) {
        if settings.id != nil { fatalError("Can't create settings with repeated id") }
        let id = 0
        settings.id = id
        self.settings = settings
    }
    
    func readSettings() -> Settings {
        guard let settings = self.settings else {
            fatalError("Can't read settings, there are none")
        }
        return settings
    }
    
    func update(settings: Settings) {
        guard settings.id != nil else { fatalError("Can't update settings without id") }
        self.settings = settings
    }
    
    func delete(settings: inout Settings) {
        guard settings.id != nil else { fatalError("Can't delete settings without id") }
        settings.id = nil
        self.settings = nil
    }
    
    
}
