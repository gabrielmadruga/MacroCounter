//
//  MainViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/7/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit
//import CoreData
import Combine

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
//        self.navigationItem.leftBarButtonItem?.isEnabled = try! context.count(for: Entry.fetchRequest()) > 0
    }
    
    @objc private func onHistoryTouch() {
        let vc = EntriesViewController.instantiate(fromStoryboard: .entry)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc private func onSettingsTouch() {
        let vc = SettingsViewController.instantiate(fromStoryboard: .settings)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupNavBarButtons() {
        var button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: "list.bullet", withConfiguration: largeConfig), for: .normal)
        button.addTarget(self, action: #selector(self.onHistoryTouch), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        button = UIButton()
        button.setImage(UIImage(systemName: "gearshape", withConfiguration: largeConfig), for: .normal)
        button.addTarget(self, action: #selector(self.onSettingsTouch), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
}
