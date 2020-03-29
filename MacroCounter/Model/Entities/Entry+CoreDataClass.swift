//
//  Entry+CoreDataClass.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/22/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Entry)
public class Entry: NSManagedObject {
    
    var macros: Macros {
        get {
            return Macros(fats: fats, carbs: carbs, proteins: proteins)
        }
    }
    
    @objc public var sectionIdentifier: String? {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let startOfDay = calendar.startOfDay(for: date!)
        let formatter = DateFormatter()
//        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MMM", options: 0, locale: Calendar.current.locale)
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter.string(from: startOfDay)
    }
    
    override public func awakeFromInsert() {
        setPrimitiveValue("Default Name", forKey: "name")
        setPrimitiveValue(Date(), forKey: "date")
    }
}
