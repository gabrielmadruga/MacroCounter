//
//  EntriesViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 1/31/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit


//protocol EntriesViewControllerDelegate: class {
//
//    func didDeleteEntry()
//}
    
class EntriesViewController: UIViewController {
    
//    weak var delegate: EntriesViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView!
    private var emptyTableMessageView: UIView!
    private weak var barsViewController: BarsViewController? {
        get {
            return self.children.first as? BarsViewController
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyTableMessageView = tableView.tableFooterView
    }
    
    deinit {
        emptyTableMessageView = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        refreshFooterView()
    }
    
    private func refreshFooterView() {
        let hasEntries = !entries.isEmpty
        let messageIsShowing = self.tableView.tableFooterView != nil
        let shouldTransition = hasEntries == messageIsShowing
        if shouldTransition {
            UIView.transition(with: self.emptyTableMessageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                if hasEntries {
                    self.tableView.tableFooterView = nil
                } else {
                    self.tableView.tableFooterView = self.emptyTableMessageView
                }
            })
        }
    }
}

extension EntriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! EntryTableViewCell
            appDelegate.repository.delete(cell.entry!)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshFooterView()
            barsViewController?.reloadData()
//            delegate?.didDeleteEntry()
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

protocol EntriesViewControllerDataSource {
    var entries: [Entry] { get }
}

extension EntriesViewController: EntriesViewControllerDataSource {
    var entries: [Entry] {
        return (appDelegate.repository.read(Entry.self) as! [Entry]).filter({ (entry) -> Bool in
            Calendar.current.isDate(entry.date, inSameDayAs: .init())
        }).sorted { (e1, e2) -> Bool in        
            e1.date < e2.date
        }
    }
}

extension EntriesViewController: UITableViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
//        case "New":
//            break
//            os_log("Adding a new entry.", log: OSLog.default, type: .debug)
        case "Edit":
            guard let addEditEntryViewController = segue.destination as? AddEditEntryViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
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
    
    
}