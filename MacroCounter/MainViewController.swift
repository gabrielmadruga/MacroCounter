//
//  MainViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/7/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateLabel = UILabel()
        dateLabel.textColor = .secondaryLabel
        dateLabel.font = .preferredFont(forTextStyle: .title3)
        dateLabel.text = formatter.string(from: .init())
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dateLabel)
        
        let someSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let addEntryButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 60)))
        addEntryButton.setTitle("Add Entry", for: .normal)
        addEntryButton.setTitleColor(.systemBlue, for: .normal)
        addEntryButton.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .highlighted)
        addEntryButton.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        addEntryButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addEntryButton.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        addEntryButton.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
        addEntryButton.addTarget(self, action: #selector(presentAddEditEntry), for: .touchUpInside)
        let addEntryBarButton = UIBarButtonItem(customView: addEntryButton)
        setToolbarItems([someSpace, addEntryBarButton], animated: true)
    }
    
    @objc private func presentAddEditEntry() {
        let nav = UIStoryboard.init(.entry).instantiateViewController(identifier: "AddEditEntry")
        self.present(nav, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "New":
            break
            // os_log("Adding a new entry.", log: OSLog.default, type: .debug)
        case "Favorites":
//            guard let entriesViewController = segue.destination as? EntriesViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
            break
        // os_log("Adding a new entry.", log: OSLog.default, type: .debug)
        default:
            break
        }
        
    }
    
}

//    func setHeight(hasEntries: Bool) {
//        DispatchQueue.main.async {
//            let tableFooterViewFrame = self.quickViewTableView.tableFooterView!.frame
//            let rowCount = self.quickViewTableView.numberOfRows(inSection: 0)
//            let tableHeaderViewFrame = self.quickViewTableView.tableHeaderView!.frame
//            var height = self.quickViewTableView.frame.minY + CGFloat(rowCount) * self.quickViewTableView.rowHeight + tableHeaderViewFrame.maxY
//            if (rowCount == 0) {
//                height += tableFooterViewFrame.height
//            }
//            self.scrollViewContentHeightConstraint.constant = height
//            if (rowCount > 0) {
//                UIView.animate(withDuration: 0.5) {
//                    self.view.layoutIfNeeded()
//                }
//            }
//        }
//    }
