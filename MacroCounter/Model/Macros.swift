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
    var fats: Float
    var carbs: Float
    var proteins: Float
    var calories: Float {
        return fats * 9 + carbs * 4 + proteins * 4
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
