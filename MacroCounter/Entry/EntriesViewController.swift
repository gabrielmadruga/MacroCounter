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
        
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Entry.date), ascending: false)]
        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: #keyPath(Entry.sectionIdentifier), cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! fetchedResultsController.performFetch()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension EntriesViewController: NSFetchedResultsControllerDelegate {
        
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! EntryTableViewCell
            cell.entry = anObject as? Entry
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}

extension EntriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, view, completionHandler) in
            let entry = self.fetchedResultsController.object(at: indexPath)
            self.context.delete(entry)
            self.saveContext()
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        func todaySectionIdentifier() -> String {
           var calendar = Calendar.current
           calendar.timeZone = NSTimeZone.local
           let startOfDay = calendar.startOfDay(for: Date())
           let formatter = DateFormatter()
   //        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MMM", options: 0, locale: Calendar.current.locale)
           formatter.dateStyle = .long
           formatter.timeStyle = .none
           
           return formatter.string(from: startOfDay)
       }
        
        let label = UILabel()
        let sectionInfo = fetchedResultsController.sections?[section]
        if sectionInfo?.name == todaySectionIdentifier() {
            label.text = "Today"
        } else {
            label.text = sectionInfo?.name
        }
        
        label.textAlignment = .center
//        label.backgroundColor = .clear
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nav = UIStoryboard.init(.entry).instantiateViewController(identifier: "AddEditEntry") as UINavigationController
        let addEditEntryVC = nav.viewControllers.first as! AddEditEntryViewController
        addEditEntryVC.title = "Edit Entry"
        addEditEntryVC.entry = fetchedResultsController.object(at: indexPath)
        self.present(nav, animated: true, completion: nil)
    }

}

extension EntriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry") as! EntryTableViewCell
        cell.entry = fetchedResultsController.object(at: indexPath)
        return cell
    }
}

// MARK: - EntryTableViewCell
class EntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
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
        nameLabel.text = entry.name
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        dateLabel.text = formatter.string(from: entry.date!)
        fatLabel.text = entry.fats.description
        carbsLabel.text = entry.carbs.description
        proteinLabel.text = entry.proteins.description
        caloriesLabel.text = entry.calories.description
//        servingsLabel.text = "x\(Int(entry.servings).description)"
    }
    
//    override func awakeFromNib() {
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
//        self.selectedBackgroundView = bgColorView
//    }
}
