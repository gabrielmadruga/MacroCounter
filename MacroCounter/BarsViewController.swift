//
//  BarsViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/1/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

class BarsViewController: UIViewController {
    
    @IBOutlet weak var goalsStackView: UIStackView!
    @IBOutlet weak var fatCurrentLabel: UILabel!
    @IBOutlet weak var fatGoalLabel: UILabel!
    @IBOutlet weak var fatProgressView: UIProgressView!
    
    @IBOutlet weak var carbsCurrentLabel: UILabel!
    @IBOutlet weak var carbsGoalLabel: UILabel!
    @IBOutlet weak var carbsProgressView: UIProgressView!
    
    @IBOutlet weak var proteinCurrentLabel: UILabel!
    @IBOutlet weak var proteinGoalLabel: UILabel!
    @IBOutlet weak var proteinProgressView: UIProgressView!
    
    @IBOutlet weak var caloriesCurrentLabel: UILabel!
    @IBOutlet weak var caloriesGoalLabel: UILabel!
    @IBOutlet weak var caloriesProgressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    @objc func reloadData() {
        let todayEntries = (appDelegate.repository.read(Entry.self) as! [Entry]).filter({ (entry) -> Bool in
            Calendar.current.isDate(entry.date, inSameDayAs: .init())
        })
        let settings = appDelegate.repository.read(Settings.self) as? [Settings]
        guard let goals = settings?.first?.goals else {
            fatalError("Goals must be set by now!")
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
        fatCurrentLabel.text = "\(Int(fatFromEntries).description)"
        fatGoalLabel.text = "\(Int(goals.fats).description)"
        carbsCurrentLabel.text = "\(Int(carbsFromEntries).description)"
        carbsGoalLabel.text = "\(Int(goals.carbs).description)"
        proteinCurrentLabel.text = "\(Int(proteinFromEntries).description)"
        proteinGoalLabel.text = "\(Int(goals.proteins).description)"
        caloriesCurrentLabel.text = "\(Int(caloriesFromEntries).description)"
        caloriesGoalLabel.text = "\(Int(goals.calories).description)"
        // Update progress views
        func capedRatioTo1(_ value: Float, _ goalValue: Float) -> Float {
            let ratio = value / goalValue
            return ratio > 1 ? 1 : ratio
        }
        fatProgressView.setProgress(capedRatioTo1(fatFromEntries, goals.fats), animated: true)
        carbsProgressView.setProgress(capedRatioTo1(carbsFromEntries, goals.carbs), animated: true)
        proteinProgressView.setProgress(capedRatioTo1(proteinFromEntries, goals.proteins), animated: true)
        caloriesProgressView.setProgress(capedRatioTo1(caloriesFromEntries, goals.calories), animated: true)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
