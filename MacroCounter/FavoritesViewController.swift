//
//  FavoritesViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/2/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var emptyTableMessageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyTableMessageView = tableView.tableFooterView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        refreshFooterView()
    }
    
    private func refreshFooterView() {
        let hasEntries = !entryTemplates.isEmpty
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

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! EntryTemplateTableViewCell
            appDelegate.repository.delete(cell.entryTemplate!)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshFooterView()
        }
    }
}

class EntryTemplateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    
    var entryTemplate: EntryTemplate! {
        didSet {
            refresh()
        }
    }
    var entry: Entry {
        get {
            entryTemplate.entry
        }
    }
    
    private func refresh() {
        nameLabel.text = entryTemplate.name
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


protocol FavoritesViewControllerDataSource {
    var entryTemplates: [EntryTemplate] { get }
}

extension FavoritesViewController: FavoritesViewControllerDataSource {
    var entryTemplates: [EntryTemplate] {
        return appDelegate.repository.read(EntryTemplate.self) as! [EntryTemplate]
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            //        case "New":
            //            break
        //            os_log("Adding a new entry.", log: OSLog.default, type: .debug)
        case "Edit":
            #warning("TODO")
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
        entryTemplates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryTemplate") as! EntryTemplateTableViewCell
        cell.entryTemplate = entryTemplates[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EntryTemplateTableViewCell
        appDelegate.repository?.create(cell.entry)
        self.navigationController?.popViewController(animated: true)
    }
}
