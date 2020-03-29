//
//  MainViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/7/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    var dayChangeStream: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayChangeStream = NotificationCenter.default.publisher(for: .NSCalendarDayChanged).receive(on: RunLoop.main).sink { notification in
            self.setupLeftBarDateButton()
        }
        setupLeftBarDateButton()
        setupToolbar()        
    }
    
    private func setupLeftBarDateButton() {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MMM", options: 0, locale: Calendar.current.locale)
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
        let dateLabel = UILabel()
        dateLabel.textColor = .secondaryLabel
        dateLabel.font = .preferredFont(forTextStyle: .title3)
        dateLabel.text = formatter.string(from: .init())
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dateLabel)
    }
    
    private func setupToolbar() {
        let entriesButton = UIBarButtonItem(title: "Entries", style: .plain, target: self, action: #selector(showEntries))
        let targetButton = UIBarButtonItem(title: "Daily Target", style: .plain, target: self, action: #selector(showDailyTarget))
        let someSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let addEntryButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44)))
        addEntryButton.setTitle("Add Entry", for: .normal)
        addEntryButton.setTitleColor(.systemBlue, for: .normal)
        addEntryButton.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .highlighted)
        addEntryButton.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        addEntryButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addEntryButton.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        addEntryButton.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
        addEntryButton.addTarget(self, action: #selector(presentAddEditEntry), for: .touchUpInside)
        let addEntryBarButton = UIBarButtonItem(customView: addEntryButton)
        setToolbarItems([targetButton, someSpace, entriesButton, someSpace, addEntryBarButton], animated: true)
    }
    
    @objc private func showEntries() {
        let vc = UIStoryboard.init(.entry).instantiateViewController(identifier: "Entries")
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func showDailyTarget() {
        let vc = UIStoryboard.init(.settings).instantiateViewController(identifier: "SetDailyTarget")
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func presentAddEditEntry() {
        let nav = UIStoryboard.init(.entry).instantiateViewController(identifier: "AddEditEntry")
        self.present(nav, animated: true, completion: nil)
    }
    
    
}
