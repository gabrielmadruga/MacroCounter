//
//  Entry+CoreDataProperties.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/22/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var servings: Float
    @NSManaged public var calories: Float
    @NSManaged public var proteins: Float
    @NSManaged public var fats: Float
    @NSManaged public var carbs: Float

}
