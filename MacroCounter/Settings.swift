//
//  Settings.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import Foundation

struct Settings {
    
    struct Goals {
        var fat: Float
        var carbs: Float
        var protein: Float
        var calories: Float {
            return fat * 9 + carbs * 4 + protein * 4
        }
    }
    
    var id: Int? = nil
    var goals: Goals
    
}
