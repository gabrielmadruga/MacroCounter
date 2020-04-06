//
//  WeightSample+CoreDataProperties.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/4/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//
//

import Foundation
import CoreData


extension WeightSample {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeightSample> {
        return NSFetchRequest<WeightSample>(entityName: "WeightSample")
    }

    @NSManaged public var profile: Profile?

}
