//
//  FavoritesViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 2/2/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

class EntryTemplatesViewController: UIViewController {
    
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

extension EntryTemplatesViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! EntryTemplateTableViewCell
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, complete) in
            self.appDelegate.repository.delete(cell.entryTemplate!)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.refreshFooterView()
            complete(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, complete) in
            self.performSegue(withIdentifier: "Edit", sender: cell)
            complete(true)
        }
        editAction.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
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
    
    var entryTemplate: EntryTemplate! {
        didSet {
            refresh()
        }
    }
    
    private func refresh() {
        nameLabel.text = entryTemplate.name
        fatLabel.text = entryTemplate.fats.description
        carbsLabel.text = entryTemplate.carbs.description
        proteinLabel.text = entryTemplate.proteins.description
        caloriesLabel.text = entryTemplate.calories.description
//        servingsLabel.text = "x\(Int(entry.servings).description)"
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

extension EntryTemplatesViewController: FavoritesViewControllerDataSource {
    var entryTemplates: [EntryTemplate] {
        return appDelegate.repository.read(EntryTemplate.self) as! [EntryTemplate]
    }
}

extension EntryTemplatesViewController: UITableViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            //        case "New":
            //            break
        //            os_log("Adding a new entry.", log: OSLog.default, type: .debug)
        case "Edit":
            #warning("TODO")
            guard let vc = segue.destination as? AddEditEntryTemplateViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let cell = sender as! EntryTemplateTableViewCell
            vc.entryTemplate = cell.entryTemplate
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
        let newEntry = Entry(macros: cell.entryTemplate.macros, servings: 1)
        #warning("servings")
        appDelegate.repository?.create(newEntry)
        self.navigationController?.popViewController(animated: true)
    }
}
