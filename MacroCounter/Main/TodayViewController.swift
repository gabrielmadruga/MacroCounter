//
//  BarsViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/1/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData
import Combine

class TodayViewController: UIViewController {
    
    var todayEntriesFetchedResultsController: NSFetchedResultsController<Entry>!
    var dailyTargetFetchedResultsController: NSFetchedResultsController<DailyTarget>!
    
    @IBOutlet weak var caloriesProgressView: ProgressView!
    @IBOutlet weak var fatProgressView: ProgressView!
    @IBOutlet weak var carbsProgressView: ProgressView!
    @IBOutlet weak var proteinProgressView: ProgressView!    
       
    var dayChangeStream: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupResultControllersAndPerformFetchAndReloadData()
        dayChangeStream = NotificationCenter.default.publisher(for: .NSCalendarDayChanged).receive(on: RunLoop.main).sink { notification in
            self.setupResultControllersAndPerformFetchAndReloadData()
        }
    }
    
    private func setupResultControllersAndPerformFetchAndReloadData() {
        todayEntriesFetchedResultsController = Entry.todayEntriesFetchedResultsController(context: context)
        todayEntriesFetchedResultsController.delegate = self
        dailyTargetFetchedResultsController = DailyTarget.dailyTargetFetchedResultsController(context: context)
        dailyTargetFetchedResultsController.delegate = self
        try! todayEntriesFetchedResultsController.performFetch()
        try! dailyTargetFetchedResultsController.performFetch()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupResultControllersAndPerformFetchAndReloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        todayEntriesFetchedResultsController = nil
        dailyTargetFetchedResultsController = nil
    }
    
    func reloadData() {
        guard let todayEntries = todayEntriesFetchedResultsController.fetchedObjects else {
            fatalError("Error fetching entries")
        }
        guard let dailyTarget = dailyTargetFetchedResultsController.fetchedObjects?.first else {
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
        
        self.caloriesProgressView.setup(name: "Calories", current: caloriesFromEntries, target: dailyTarget.calories, unit: "CAL", color: .systemBlue)
        self.fatProgressView.setup(name: "Fats", current: fatFromEntries, target: dailyTarget.fats, unit: "G", color: .systemYellow)
        self.carbsProgressView.setup(name: "Carbs", current: carbsFromEntries, target: dailyTarget.carbs, unit: "G", color: .systemGreen)
        self.proteinProgressView.setup(name: "Proteins", current: proteinFromEntries, target: dailyTarget.proteins, unit: "G", color: .systemRed)
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
