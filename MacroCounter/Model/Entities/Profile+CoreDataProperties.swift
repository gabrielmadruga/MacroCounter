//
//  Profile+CoreDataProperties.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/7/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var height: Int16
    @NSManaged public var isMale: Bool
    @NSManaged public var physicalActivityLevel: Float
    @NSManaged public var dailyTarget: DailyTarget?
    @NSManaged public var currentWeight: WeightSample?

}
