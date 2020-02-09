//
//  Entry.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import Foundation


struct Macros: Codable {
    var fats: Float
    var carbs: Float
    var proteins: Float
    var calories: Float {
        return fats * 9 + carbs * 4 + proteins * 4
    }
}

protocol Macroable {
    var macros: Macros { get set }
}

extension Macroable {
    var fats: Float {
        get {
            return macros.fats
        }
        set {
            macros.fats = newValue
        }
    }
    var carbs: Float {
        get {
            return macros.carbs
        }
        set {
            macros.carbs = newValue
        }
    }
    var proteins: Float {
        get {
            return macros.proteins
        }
        set {
            macros.proteins = newValue
        }
    }
    var calories: Float {
        return macros.calories
    }
}

struct Entry: Codable, Macroable {
    var id: Int?
    
    var date: Date
    var macros: Macros
//    var fats: Float {
//        return macros.fats * servings
//    }
//    var carbs: Float {
//        return macros.carbs * servings
//    }
//    var proteins: Float {
//        return macros.proteins * servings
//    }
//    var calories: Float {
//        return macros.calories * servings
//    }
    
    var servings: Float
    
    init(macros: Macros, servings: Float, date: Date = Date.init()) {
        id = nil
        self.date = date
        self.macros = macros
        self.servings = servings
    }

}

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
