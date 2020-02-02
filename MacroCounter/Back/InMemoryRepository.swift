//
//  InMemoryRepository.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import Foundation

class InMemoryRepository: Repository {
    
    var entries: [Int: Entry] = [:]
    var entryTemplates: [Int: EntryTemplate] = [:]
    var settings: Settings? = nil
    
    func create(_ item: Any) {
        switch item {
        case var entry as Entry:
            if entry.id != nil { fatalError("Can't create entry with repeated id") }
            let id = Array(entries.keys).count
            entry.id = id
            entries[id] = entry
        case var entryTemplate as EntryTemplate:
            if entryTemplate.id != nil { fatalError("Can't create entry template with repeated id") }
            let id = Array(entryTemplates.keys).count
            entryTemplate.id = id
            entryTemplates[id] = entryTemplate
        case var settings as Settings:
            settings.id = 0
            self.settings = settings
        default:
            fatalError()
        }
    }
    
    func read(_ type: Any.Type) -> [Any] {
        switch type {
        case is Entry.Type:
            return Array(entries.values)
        case is EntryTemplate.Type:
            return Array(entryTemplates.values)
        case is Settings.Type:
            if let settings = self.settings {
                return [settings]
            } else {
                return []
            }
        default:
            fatalError()
        }
    }
    
    func update(_ item: Any) {
        switch item {
        case let entry as Entry:
            guard let id = entry.id else { fatalError("Can't update entry without id") }
            entries[id] = entry
        case let entryTemplate as EntryTemplate:
            guard let id = entryTemplate.id else { fatalError("Can't update entry template without id") }
            entryTemplates[id] = entryTemplate
        case let settings as Settings:
             self.settings = settings
        default:
            fatalError()
        }
    }
    
    func delete(_ item: Any) {
        switch item {
        case let entry as Entry:
            guard let id = entry.id else { fatalError("Can't delete entry without id") }
            entries[id] = nil
        case let entryTemplate as EntryTemplate:
            guard let id = entryTemplate.id else { fatalError("Can't delete entry template without id") }
            entryTemplates[id] = nil
        case is Settings:
            self.settings = nil
        default:
            fatalError()
        }
    }
}
