//
//  DatePickerViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

extension UIAlertController {
        
    /// Add a date picker
    ///
    /// - Parameters:
    ///   - mode: date picker mode
    ///   - date: selected date of date picker
    ///   - minimumDate: minimum date of date picker
    ///   - maximumDate: maximum date of date picker
    ///   - action: an action for datePicker value change
    func addDatePicker(mode: UIDatePicker.Mode,
                       date: Date?,
                       minimumDate: Date? = nil,
                       maximumDate: Date? = nil,
                       action: DatePickerViewController.Action?) {
        let datePickerViewController = DatePickerViewController(mode: mode,
                                                                date: date,
                                                                minimumDate: minimumDate,
                                                                maximumDate: maximumDate,
                                                                action: action)
        setValue(datePickerViewController, forKey: "contentViewController")
        let height: CGFloat = 217
        datePickerViewController.preferredContentSize.height = height
        preferredContentSize.height = height
    }
}

final class DatePickerViewController: UIViewController {
    
    public typealias Action = (Date) -> Void
    fileprivate var action: Action?
    fileprivate var datePicker: UIDatePicker!
    
    required init(mode: UIDatePicker.Mode, date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: Action?) {
        super.init(nibName: nil, bundle: nil)
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(DatePickerViewController.actionForDatePicker), for: .valueChanged)
        datePicker.datePickerMode = mode
        datePicker.date = date ?? Date()
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = datePicker
    }
    
    @objc func actionForDatePicker() {
        action?(datePicker.date)
    }
    
    public func setDate(_ date: Date) {
        datePicker.setDate(date, animated: true)
    }
}
