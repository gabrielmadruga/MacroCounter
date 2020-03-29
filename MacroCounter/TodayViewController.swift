//
//  BarsViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/1/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData
		
class TodayViewController: UIViewController {
    
    lazy var fetchedTodayEntriesResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = todayEntriesPredicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    lazy var todayEntriesPredicate: NSPredicate = {
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
    }()
    
    lazy var fetchedDailyTargetResultsController: NSFetchedResultsController<DailyTarget> = {
        let fetchRequest: NSFetchRequest<DailyTarget> = DailyTarget.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(DailyTarget.calories), ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    @IBOutlet weak var caloriesProgressView: ProgressView!
    @IBOutlet weak var fatProgressView: ProgressView!
    @IBOutlet weak var carbsProgressView: ProgressView!
    @IBOutlet weak var proteinProgressView: ProgressView!
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! fetchedTodayEntriesResultsController.performFetch()
        try! fetchedDailyTargetResultsController.performFetch()
        reloadData()
    }
    
    func reloadData() {
        guard let todayEntries = fetchedTodayEntriesResultsController.fetchedObjects else {
            fatalError("Error fetching entries")
        }
        guard let dailyTarget = fetchedDailyTargetResultsController.fetchedObjects?.first else {
            fatalError("A daily target must be set by now!")
        }
        let fatFromEntries = todayEntries.reduce(into: 0.0) { (current, entry) in
            current = current + entry.fats * entry.servings
        }
        let carbsFromEntries = todayEntries.reduce(into: 0.0) { (current, entry) in
            current = current + entry.carbs * entry.servings
        }
        let proteinFromEntries = todayEntries.reduce(into: 0.0) { (current, entry) in
            current = current + entry.proteins * entry.servings
        }
        let caloriesFromEntries = todayEntries.reduce(into: 0.0) { (current, entry) in
            current = current + entry.calories * entry.servings
        }
        
        caloriesProgressView.setup(name: "Calories", current: caloriesFromEntries, target: dailyTarget.calories, unit: "CAL", color: .systemBlue)
        fatProgressView.setup(name: "Fats", current: fatFromEntries, target: dailyTarget.fats, unit: "G", color: .systemYellow)
        carbsProgressView.setup(name: "Carbs", current: carbsFromEntries, target: dailyTarget.carbs, unit: "G", color: .systemGreen)
        proteinProgressView.setup(name: "Proteins", current: proteinFromEntries, target: dailyTarget.proteins, unit: "G", color: .systemRed)
        
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension TodayViewController: NSFetchedResultsControllerDelegate {
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//
//    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reloadData()
    }
}
