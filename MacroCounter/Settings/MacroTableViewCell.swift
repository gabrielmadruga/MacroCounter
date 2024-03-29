//
//  MacroCell.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/2/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

class MacroTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var overrideButton: UIButton!
    weak var caloriesTableViewCell: MacroTableViewCell!
    
    private var macroOwner: HasMacros!
    private var type: MacroType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadFromNib()
        overrideButton.isHidden = true
        numberTextField.addTarget(self, action: #selector(onTextEditingChanged), for: .editingChanged)
    }

    private var onChange: (() -> ())?
    
    func setup(type: MacroType, macroOwner: HasMacros, calsCell: MacroTableViewCell, onChange: (() -> ())? = nil) {
        self.type = type
        self.macroOwner = macroOwner
        self.caloriesTableViewCell = calsCell
        self.onChange = onChange
        setup()
        reloadData()
        if type == .calories {
            if macroOwner.macros.calories != macroOwner.calories {
                overrideButton.isHidden = false
            }
        }
    }
    
    @objc func onTextEditingChanged(_ textField: UITextField) {
        if let value = textField.parseFloatAndAdjust() {
            setValue(value)
        } else {
            setValue(0)
            textField.text = ""
        }
    }
    
    func value() -> Float {
        switch type {
        case .calories:
            return macroOwner.calories
        case .fats:
            return macroOwner.fats
        case .carbs:
            return macroOwner.carbs
        case .proteins:
            return macroOwner.proteins
        default:
            fatalError()
        }
    }
    
    func setValue(_ value: Float) {
        switch type {
        case .calories:
            macroOwner.calories = value
            if macroOwner.macros.calories != value {
                overrideButton.isHidden = false                
            }
        case .fats:
            macroOwner.fats = value
            reCalcCalsAndReloadIfNeeded()
        case .carbs:
            macroOwner.carbs = value
            reCalcCalsAndReloadIfNeeded()
        case .proteins:
            macroOwner.proteins = value
            reCalcCalsAndReloadIfNeeded()
        default:
            fatalError()
        }
        DispatchQueue.main.async {
            self.onChange?()
        }
    }
    private func reCalcCalsAndReloadIfNeeded() {
        if caloriesTableViewCell.overrideButton.isHidden {
            caloriesTableViewCell.setValue(macroOwner.macros.calories)
            caloriesTableViewCell.reloadData()
        }
    }
    func reloadData() {
        switch type {
        case .calories:
            numberTextField.text = Int(round(macroOwner.calories)).description
        case .fats:
            numberTextField.text = Int(round(macroOwner.fats)).description
        case .carbs:
            numberTextField.text = Int(round(macroOwner.carbs)).description
        case .proteins:
            numberTextField.text = Int(round(macroOwner.proteins)).description
        default:
            fatalError()
        }
    }
    private func setup() {
        switch type {
        case .calories:
            nameLabel.text = "Calories (cal)"
            numberTextField.tag = 1
        case .fats:
            nameLabel.text = "Fats (g)"
            numberTextField.tag = 2
        case .carbs:
            nameLabel.text = "Carbs (g)"
            numberTextField.tag = 3
        case .proteins:
            nameLabel.text = "Protein (g)"
            numberTextField.tag = 4
        default:
            fatalError()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        if let formVC = self.parentViewController as? FormViewController {
            formVC.setupKeyboardToolbar(for: textField)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        reloadData()
    }
    
    @IBAction func undoOverrideCalories(_ sender: Any) {
        overrideButton.isHidden = true
        numberTextField.resignFirstResponder()        
        caloriesTableViewCell.setValue(macroOwner.macros.calories)
        caloriesTableViewCell.reloadData()
    }
}
