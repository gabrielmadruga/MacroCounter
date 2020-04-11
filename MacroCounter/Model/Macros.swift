//
//  File.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/22/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import Foundation


enum MacroType {
    case calories, fats, carbs, proteins
}

struct Macros: Codable {
    static let calsPerFat: Float = 9
    static let calsPerCarb: Float = 4
    static let calsPerProt: Float = 4
    
    var fats: Float
    var carbs: Float
    var proteins: Float
    var calories: Float {
        return fats * Macros.calsPerFat + carbs * Macros.calsPerCarb + proteins * Macros.calsPerProt
    }
}

protocol HasMacros {
    var fats: Float { get set }
    var carbs: Float { get set }
    var proteins: Float { get set }
    var calories: Float { get set }
}

protocol Macroable {
    var macros: Macros { get set }
}

extension HasMacros {
    var macros: Macros {
        get {
            return Macros(fats: fats, carbs: carbs, proteins: proteins)
        }
    }
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
