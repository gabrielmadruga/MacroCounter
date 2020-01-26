//
//  MainViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/7/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

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

    @IBOutlet weak var quickViewTableView: UITableView!
    
    
    @IBOutlet weak var scrollViewContentHeightConstraint: NSLayoutConstraint!
    
    func setHeight(_ hasEntries: Bool) {
        DispatchQueue.main.async {
            let tableFooterViewFrame = self.quickViewTableView.tableFooterView!.frame
            let height = self.quickViewTableView.frame.minY + (hasEntries ? tableFooterViewFrame.minY : tableFooterViewFrame.maxY)
            self.scrollViewContentHeightConstraint.constant = height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let hasEntries = !appDelegate.repository.readEntries(day: Date.init()).isEmpty
        quickViewTableView.tableFooterView!.isHidden = hasEntries
        refreshGoals()
        quickViewTableView.reloadData()
        setHeight(hasEntries)
    }
    
    private func refreshGoals() {
        guard let goals = appDelegate.repository.readSettings()?.goals else {
            fatalError("Goals must be set by now!")
        }
        let fatFromEntries = appDelegate.repository.readEntries(day: Date.init()).reduce(into: 0.0) { (current, entry) in
            current = current + entry.fat
        }
        let carbsFromEntries = appDelegate.repository.readEntries(day: Date.init()).reduce(into: 0.0) { (current, entry) in
            current = current + entry.carbs
        }
        let proteinFromEntries = appDelegate.repository.readEntries(day: Date.init()).reduce(into: 0.0) { (current, entry) in
            current = current + entry.protein
        }
        let caloriesFromEntries = appDelegate.repository.readEntries(day: Date.init()).reduce(into: 0.0) { (current, entry) in
            current = current + entry.calories
        }
        // Update labels
        fatCurrentLabel.text = "\(Int(fatFromEntries).description)"
        fatGoalLabel.text = "\(Int(goals.fat).description)"
        carbsCurrentLabel.text = "\(Int(carbsFromEntries).description)"
        carbsGoalLabel.text = "\(Int(goals.carbs).description)"
        proteinCurrentLabel.text = "\(Int(proteinFromEntries).description)"
        proteinGoalLabel.text = "\(Int(goals.protein).description)"
        caloriesCurrentLabel.text = "\(Int(caloriesFromEntries).description)"
        caloriesGoalLabel.text = "\(Int(goals.calories).description)"
        // Update progress views
        func capedRatioTo1(_ value: Float, _ goalValue: Float) -> Float {
            let ratio = value / goalValue
            return ratio > 1 ? 1 : ratio
        }
        fatProgressView.setProgress(capedRatioTo1(fatFromEntries, goals.fat), animated: true)
        carbsProgressView.setProgress(capedRatioTo1(carbsFromEntries, goals.carbs), animated: true)
        proteinProgressView.setProgress(capedRatioTo1(proteinFromEntries, goals.protein), animated: true)
        caloriesProgressView.setProgress(capedRatioTo1(caloriesFromEntries, goals.calories), animated: true)
    }
    
}

class QuickViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    var entry: Entry! {
        didSet {
            refresh()
        }
    }
    
    private func refresh() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        dateLabel.text = formatter.string(from: entry.date)
        fatLabel.text = entry.fat.description
        carbsLabel.text = entry.carbs.description
        proteinLabel.text = entry.protein.description
        caloriesLabel.text = entry.calories.description
    }
    
    override func awakeFromNib() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.selectedBackgroundView = bgColorView
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entries = appDelegate.repository.readEntries(day: Date.init())
            var entry = entries[indexPath.row]
            appDelegate.repository.delete(entry: &entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.refreshGoals()
            setHeight(!entries.isEmpty)
                
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//            return
//        }
    }

    
}

extension MainViewController: UITableViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "New":
            break
            // os_log("Adding a new entry.", log: OSLog.default, type: .debug)
        case "Edit":
            guard let addEditEntryViewController = segue.destination as? AddEditEntryViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? QuickViewTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = quickViewTableView.indexPath(for: cell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let entry = appDelegate.repository.readEntries(day: Date.init())[indexPath.row]
            addEditEntryViewController.entry = entry
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.repository.readEntries(day: Date.init()).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry") as! QuickViewTableViewCell
        cell.entry = appDelegate.repository.readEntries(day: Date.init())[indexPath.row]
        return cell
    }
    
    
}
