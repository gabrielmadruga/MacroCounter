//
//  DailyTarget+CoreDataClass.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/22/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DailyTarget)
public class DailyTarget: NSManagedObject, HasMacros {
        
    class func dailyTargetFetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController<DailyTarget> {
        let fetchRequest: NSFetchRequest<DailyTarget> = DailyTarget.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(DailyTarget.calories), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
}
