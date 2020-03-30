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
    
    class func todayEntriesFetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController<Entry> {
        func todayEntriesPredicate() -> NSPredicate {
            // Get the current calendar with local time zone
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            
            // Get today's beginning & end
            let dateFrom = calendar.startOfDay(for: Date())
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
            
            let fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(Entry.date), dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Entry.date), dateTo as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            return datePredicate
        }
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = todayEntriesPredicate()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
}
