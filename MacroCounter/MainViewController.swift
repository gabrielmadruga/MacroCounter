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
