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
    
    @IBOutlet weak var dailyTargetStackView: UIStackView!
    @IBOutlet weak var caloriesProgressView: UIProgressView!
    @IBOutlet weak var fatProgressView: UIProgressView!
    @IBOutlet weak var carbsProgressView: UIProgressView!
    @IBOutlet weak var proteinProgressView: UIProgressView!
    
//    @IBOutlet weak var caloriesCurrentLabel: UILabel!
//    @IBOutlet weak var caloriesGoalLabel: UILabel!
//
//    @IBOutlet weak var fatCurrentLabel: UILabel!
//    @IBOutlet weak var fatGoalLabel: UILabel!
//
//    @IBOutlet weak var carbsCurrentLabel: UILabel!
//    @IBOutlet weak var carbsGoalLabel: UILabel!
//
//    @IBOutlet weak var proteinCurrentLabel: UILabel!
//    @IBOutlet weak var proteinGoalLabel: UILabel!
       
    
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
        // Update labels
//        fatCurrentLabel.text = "\(Int(fatFromEntries).description)"
//        fatGoalLabel.text = "\(Int(dailyTarget.fats).description)"
//        carbsCurrentLabel.text = "\(Int(carbsFromEntries).description)"
//        carbsGoalLabel.text = "\(Int(dailyTarget.carbs).description)"
//        proteinCurrentLabel.text = "\(Int(proteinFromEntries).description)"
//        proteinGoalLabel.text = "\(Int(dailyTarget.proteins).description)"
//        caloriesCurrentLabel.text = "\(Int(caloriesFromEntries).description)"
//        caloriesGoalLabel.text = "\(Int(dailyTarget.calories).description)"
        // Update progress views
        func capedRatioTo1(_ value: Float, _ goalValue: Float) -> Float {
            let ratio = value / goalValue
            return ratio > 1 ? 1 : ratio
        }
        fatProgressView.setProgress(capedRatioTo1(fatFromEntries, dailyTarget.fats), animated: false)
        carbsProgressView.setProgress(capedRatioTo1(carbsFromEntries, dailyTarget.carbs), animated: false)
        proteinProgressView.setProgress(capedRatioTo1(proteinFromEntries, dailyTarget.proteins), animated: false)
        caloriesProgressView.setProgress(capedRatioTo1(caloriesFromEntries, dailyTarget.calories), animated: false)
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
