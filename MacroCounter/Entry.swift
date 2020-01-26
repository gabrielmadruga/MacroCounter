//
//  Entry.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import Foundation

struct Entry: Codable {
    var id: Int?
    
    var date: Date
    
    var fat: Float
    var carbs: Float
    var protein: Float
    var calories: Float {
        return fat * 9 + carbs * 4 + protein * 4
    }
    var servings: Float
    
    init(fat: Float, carbs: Float, protein: Float, servings: Float, date: Date = Date.init()) {
        id = nil
        self.date = date
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
        self.servings = servings
    }
    
    func clone(from entry: Entry, id: Int) -> Entry {
        var entry = Entry(fat: entry.fat,
                          carbs: entry.carbs,
                          protein: entry.protein,
                          servings: entry.servings,
                          date: entry.date)
        entry.id = id
        return entry
    }
    
}
