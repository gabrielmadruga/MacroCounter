//
//  EntriesViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 1/31/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

protocol EntriesViewControllerDelegate: class {
    
    func didDeleteEntry()
}
    
class EntriesViewController: UIViewController {
    
    weak var delegate: EntriesViewControllerDelegate?
    var isFavorites = false {
        didSet {
            title = "Favorites"
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerViewTitleLabel: UILabel!
    private var emptyTableMessageView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyTableMessageView = tableView.tableFooterView
        if isFavorites {
            tableView.tableHeaderView = nil
        }
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
        if let footerView = tableView.tableFooterView, footerView.isHidden != hasEntries {
            UIView.transition(with: footerView, duration: 0.5, options: .transitionCrossDissolve, animations: {
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
            let cell = tableView.cellForRow(at: indexPath) as! QuickViewTableViewCell
            appDelegate.repository.delete(entry: &cell.entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshFooterView()
            delegate?.didDeleteEntry()
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//            return
//        }
    }

    
}

protocol EntriesViewControllerDataSource {
    var entries: [Entry] { get }
}

extension EntriesViewController: EntriesViewControllerDataSource {
    var entries: [Entry] {
        if isFavorites {
            return appDelegate.repository.readEntries().filter({ $0.isFavorite })
        }
        return appDelegate.repository.readEntries(day: Date.init()).sorted { (e1, e2) -> Bool in
            e1.date < e2.date
        }
    }
    
    
}

extension EntriesViewController: UITableViewDataSource {
    
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
        entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry") as! QuickViewTableViewCell
        cell.entry = entries[indexPath.row]
        return cell
    }
    
    
}
