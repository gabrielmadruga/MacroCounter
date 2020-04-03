//
//  SetGoalViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/21/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData

extension SetDailyTargetViewController: FormViewControllerDelegate {
        
    func validate() -> Bool {
        return true
    }
    
    func delete() {
//        self.childContext.delete(self.dailyTarget!)
//        try! self.childContext.save()
//        self.saveContext()
    }
    
}

class SetDailyTargetViewController: FormViewController, UITextFieldDelegate {
    

    @IBOutlet weak var fatTableViewCell: MacroTableViewCell!
    @IBOutlet weak var carbsTableViewCell: MacroTableViewCell!
    @IBOutlet weak var proteinTableViewCell: MacroTableViewCell!
    @IBOutlet weak var caloriesTableViewCell: MacroTableViewCell!
    
    private var dailyTarget: DailyTarget!
    
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        
        let fetchRequest: NSFetchRequest<DailyTarget> = DailyTarget.fetchRequest()
        if let dailyTarget = try? childContext.fetch(fetchRequest).first {
            self.dailyTarget = dailyTarget
            fatTableViewCell.setup(type: .fats, macroOwner: dailyTarget, calsCell: caloriesTableViewCell)
            carbsTableViewCell.setup(type: .carbs, macroOwner: dailyTarget, calsCell: caloriesTableViewCell)
            proteinTableViewCell.setup(type: .proteins, macroOwner: dailyTarget, calsCell: caloriesTableViewCell)
            caloriesTableViewCell.setup(type: .calories, macroOwner: dailyTarget, calsCell: caloriesTableViewCell)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        switch indexPath.section {
        case 3:
            switch indexPath.row {
            case 0:
                caloriesTableViewCell.numberTextField.becomeFirstResponder()
            case 1:
                fatTableViewCell.numberTextField.becomeFirstResponder()
            case 2:
                carbsTableViewCell.numberTextField.becomeFirstResponder()
            case 3:
                proteinTableViewCell.numberTextField.becomeFirstResponder()
            default:
                return
            }
        default:
            return
        }
    }
    
}
