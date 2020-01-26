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
    
    func setHeight(hasEntries: Bool) {
        DispatchQueue.main.async {
            let tableFooterViewFrame = self.quickViewTableView.tableFooterView!.frame
            let rowCount = self.quickViewTableView.numberOfRows(inSection: 0)
            let tableHeaderViewFrame = self.quickViewTableView.tableHeaderView!.frame
            var height = self.quickViewTableView.frame.minY + CGFloat(rowCount) * self.quickViewTableView.rowHeight + tableHeaderViewFrame.maxY
            if (rowCount == 0) {
                height += tableFooterViewFrame.height
            }
            self.scrollViewContentHeightConstraint.constant = height
            if (rowCount > 0) {
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        quickViewTableView.reloadData()
        realoadNonTableData()
    }
    
    private func realoadNonTableData() {
        let hasEntries = !appDelegate.repository.readEntries(day: Date.init()).isEmpty
        if self.quickViewTableView.tableFooterView!.isHidden != hasEntries {
            UIView.transition(with: self.quickViewTableView.tableFooterView!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.quickViewTableView.tableFooterView!.isHidden = hasEntries
            })
        }
        setHeight(hasEntries: hasEntries)
        refreshGoals()
    }
    
    private func refreshGoals() {
        guard let goals = appDelegate.repository.readSettings()?.goals else {
            fatalError("Goals must be set by now!")
        }
        let fatFromEntries = appDelegate.repository.readEntries(day: Date.init()).reduce(into: 0.0) { (current, entry) in
            current = current + entry.fat * entry.servings
        }
        let carbsFromEntries = appDelegate.repository.readEntries(day: Date.init()).reduce(into: 0.0) { (current, entry) in
            current = current + entry.carbs * entry.servings
        }
        let proteinFromEntries = appDelegate.repository.readEntries(day: Date.init()).reduce(into: 0.0) { (current, entry) in
            current = current + entry.protein * entry.servings
        }
        let caloriesFromEntries = appDelegate.repository.readEntries(day: Date.init()).reduce(into: 0.0) { (current, entry) in
            current = current + entry.calories * entry.servings
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
    @IBOutlet weak var servingsLabel: UILabel!
    
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
        servingsLabel.text = "x\(Int(entry.servings).description)"
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
            let cell = tableView.cellForRow(at: indexPath) as! QuickViewTableViewCell
            appDelegate.repository.delete(entry: &cell.entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(250)) {
                self.realoadNonTableData()
            }
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
            let cell = sender as! QuickViewTableViewCell
            addEditEntryViewController.entry = cell.entry
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.repository.readEntries(day: Date.init()).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry") as! QuickViewTableViewCell
        var entries = appDelegate.repository.readEntries(day: Date.init())
        entries.sort { (e1, e2) -> Bool in
            e1.date < e2.date
        }
        cell.entry = entries[indexPath.row]
        return cell
    }
    
    
}
