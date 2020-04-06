//
//  DailyTarget+CoreDataProperties.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/22/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyTarget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTarget> {
        return NSFetchRequest<DailyTarget>(entityName: "DailyTarget")
    }

    @NSManaged public var fats: Float
    @NSManaged public var carbs: Float
    @NSManaged public var proteins: Float
    @NSManaged public var calories: Float
    @NSManaged public var profile: Profile?

}
