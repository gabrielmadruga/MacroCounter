//
//  BarsViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/1/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData
		
class BarsViewController: UIViewController {
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @objc func reloadData() {
        let todayEntries = try! appDelegate.persistentContainer.viewContext.fetch(Entry.fetchRequest() as NSFetchRequest<Entry>)
            
        guard let dailyTarget = (try? appDelegate.persistentContainer.viewContext.fetch(DailyTarget.fetchRequest() as NSFetchRequest<DailyTarget>))?.first else {
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
