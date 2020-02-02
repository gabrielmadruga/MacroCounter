//
//  Repository.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import Foundation


protocol Repository {
    
    func create(_ item: Any)
    func read(_ type: Any.Type) -> [Any]
    func update(_ item: Any)
    func delete(_ item: Any)

}
