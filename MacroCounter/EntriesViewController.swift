//
//  EntriesViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 1/31/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData


class EntriesViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    var entries: [Entry] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.coreData.managedContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        let asyncFetchRequest = NSAsynchronousFetchRequest<Entry>(fetchRequest: fetchRequest) { [unowned self] (result: NSAsynchronousFetchResult) in
            guard let entries = result.finalResult else {
                return
            }
            self.entries = entries
        }
        try! managedContext.execute(asyncFetchRequest)
    }
}

extension EntriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! EntryTableViewCell
            managedContext.delete(cell.entry!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

class EntryTableViewCell: UITableViewCell {
    
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
        dateLabel.text = formatter.string(from: entry.date!)
        fatLabel.text = entry.fats.description
        carbsLabel.text = entry.carbs.description
        proteinLabel.text = entry.proteins.description
        caloriesLabel.text = entry.calories.description
        servingsLabel.text = "x\(Int(entry.servings).description)"
    }
    
//    override func awakeFromNib() {
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
//        self.selectedBackgroundView = bgColorView
//    }
}

extension EntriesViewController: AddEditEntryViewControllerDelegate {
    
    func didSaveEntry() {
        #warning("Change to tableView.added")
        tableView.reloadData()
    }
    
    func didDeleteEntry() {
        #warning("Change to tableView.deleteRows(at: [indexPath], with: .fade)")
        tableView.reloadData()
    }
}

extension EntriesViewController: UITableViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let addEditEntryViewController = (segue.destination as? UINavigationController)?.viewControllers.first as? AddEditEntryViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        addEditEntryViewController.delegate = self
        switch(segue.identifier ?? "") {
//        case "New":
//
//            os_log("Adding a new entry.", log: OSLog.default, type: .debug)
        case "Edit":
            let cell = sender as! EntryTableViewCell
            addEditEntryViewController.entry = cell.entry
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry") as! EntryTableViewCell
        cell.entry = entries[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
