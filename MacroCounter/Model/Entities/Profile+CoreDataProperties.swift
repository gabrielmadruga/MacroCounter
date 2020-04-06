//
//  Profile+CoreDataProperties.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/4/20.
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
    @NSManaged public var weightLog: NSSet?
    @NSManaged public var dailyTarget: DailyTarget?

}

// MARK: Generated accessors for weightLog
extension Profile {

    @objc(addWeightLogObject:)
    @NSManaged public func addToWeightLog(_ value: WeightSample)

    @objc(removeWeightLogObject:)
    @NSManaged public func removeFromWeightLog(_ value: WeightSample)

    @objc(addWeightLog:)
    @NSManaged public func addToWeightLog(_ values: NSSet)

    @objc(removeWeightLog:)
    @NSManaged public func removeFromWeightLog(_ values: NSSet)

}
