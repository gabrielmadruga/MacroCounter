////
////  FileRepository.swift
////  MacroCounter
////
////  Created by Gabriel Madruga on 1/26/20.
////  Copyright © 2020 Gabriel Madruga. All rights reserved.
////

import Foundation

class FileRepository: InMemoryRepository {
    
    override init() {
        super.init()
        loadSate()
    }
    
    override func create(_ item: Any) {
        super.create(item)
        saveState()
    }
    
//    override func read(_ type: Any.Type) -> [Any] {
//        return super.read(type)
//    }
    
    override func update(_ item: Any) {
        super.update(item)
        saveState()
    }
    
    override func delete(_ item: Any) {
        super.delete(item)
        saveState()
    }
    
    private func saveState() {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try? encoder.encode(state)
        url.appendPathComponent("state.json")
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    private func loadSate() {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("state.json")
        guard let data = FileManager.default.contents(atPath: url.path) else {
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        state = try! decoder.decode(State.self, from: data)
    }
}
