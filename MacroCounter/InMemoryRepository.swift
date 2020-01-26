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
        let id = Array(entries.keys).count
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
    
    func createOrUpdate(settings: Settings) {
        self.settings = settings
    }
    
    func readSettings() -> Settings? {
            return settings
    }
    
    func delete(settings: Settings) {
        self.settings = nil
    }
    
}
