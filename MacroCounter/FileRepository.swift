//
//  FileRepository.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 1/26/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import Foundation


public class FileRepository: Repository {
    
    let memoryRepo = InMemoryRepository()
    
    func create(entry: inout Entry) {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        entry.id = Int(entry.date.timeIntervalSince1970)
        url.appendPathComponent("entries", isDirectory: true)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)

        let encoder = JSONEncoder()
        let data = try? encoder.encode(entry)
        url.appendPathComponent("\(entry.id!).json")
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    func readEntries() -> [Entry] {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("entries", isDirectory: true)
        guard let urls = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: [.skipsHiddenFiles]) else {
            return []
        }
        return urls.map { url -> Entry in
            let data = FileManager.default.contents(atPath: url.path)!
            let decoder = JSONDecoder()
            let entry = try! decoder.decode(Entry.self, from: data)
            return entry
        }
    }
    
    func readEntries(day: Date) -> [Entry] {
        return readEntries().filter({ (entry) -> Bool in
            Calendar.current.isDate(entry.date, inSameDayAs: day)
        })
    }
    
    func update(entry: Entry) {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let encoder = JSONEncoder()
        let data = try? encoder.encode(entry)
        url.appendPathComponent("entries/\(entry.id!).json")
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    func delete(entry: inout Entry) {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("entries/\(entry.id!).json")
        try? FileManager.default.removeItem(at: url)
        entry.id = nil
    }
    
    func createOrUpdate(settings: Settings) {
        memoryRepo.createOrUpdate(settings: settings)
    }
    
    func readSettings() -> Settings? {
        return memoryRepo.readSettings()
    }
    
    func delete(settings: inout Settings) {
        memoryRepo.delete(settings: &settings)
    }
}
