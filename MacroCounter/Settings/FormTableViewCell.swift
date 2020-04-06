//
//  FormTableViewCell.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/4/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

enum FormTableViewCellType {
    case birthdate
    case selection
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    private var type: FormTableViewCellType!
    private var options: [[String]]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadFromNib()
    }

    func setupForBirthdate() {
        nameLabel.text = "Birthdate"
        self.type = .birthdate
        
        let ninetyYearsAgo = Calendar.current.date(byAdding: .year, value: -90, to: Date())
        let twelveYearsAgo = Calendar.current.date(byAdding: .year, value: -12, to: Date())
        let thirtyYearsAgo = Calendar.current.date(byAdding: .year, value: -30, to: Date())
        let datePicker = UIDatePicker()
        datePicker.minimumDate = ninetyYearsAgo
        datePicker.maximumDate = twelveYearsAgo
        datePicker.date = thirtyYearsAgo!
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(onDatePickerChange(_:)), for: .valueChanged)
        textField.tintColor = .clear
        textField.inputView = datePicker
    }

    func setupForSelection(label: String, options: [String]) {
        nameLabel.text = label
        self.type = .selection
        self.options = [options]
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        textField.tintColor = .clear
        textField.inputView = picker
    }
    
    func setupForInteger(label: String, from: Int, to: Int, unit: String) {
        nameLabel.text = label
        self.type = .selection
        
        options = [[Int](from...to).map({ (i) -> String in
            return "\(i) \(unit)"
        })]
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        textField.tintColor = .clear
        textField.inputView = picker
    }
    
    func setupForFloat(label: String, from: Int, to: Int, unit: String) {
        nameLabel.text = label
        self.type = .selection
        
        options = []
        options.append([Int](from...to).map({ (i) -> String in
            return "\(i)"
        }))
        options.append([Int](0...9).map({ (i) -> String in
            return ".\(i)"
        }))
        options.append(["kg"])
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        textField.tintColor = .clear
        textField.inputView = picker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var text = ""
        for i in 0..<options.count {
            if i == options.count - 1 {
                text += " "
            }
            text += options[i][pickerView.selectedRow(inComponent: i)]
        }
        textField.text = text
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if options.count > 1 {
            return 50
        }
        return 100
    }
    
    @objc
    private func onDatePickerChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        textField.text = formatter.string(from: sender.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let picker = textField.inputView as? UIPickerView {
//            Placeholder
            picker.selectRow(80, inComponent: 0, animated: true)
        }
    }
}
