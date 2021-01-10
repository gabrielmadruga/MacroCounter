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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
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
    
#if false

    private func setupToolbar() {
        let profileButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(showProfile))
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
        setToolbarItems([addEntryBarButton, someSpace, profileButton, targetButton], animated: true)
    }
    
    @objc private func showDailyTarget() {
        let vc = DailyTargetViewController.instantiate(fromStoryboard: .settings)
        //        self.navigationController?.pushViewController(vc, animated: true)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func showProfile() {
        let vc = UIStoryboard(.settings).instantiateViewController(withIdentifier: "ProfileViewController")
        //        self.navigationController?.pushViewController(vc, animated: true)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func presentAddEditEntry() {
        let nav = UIStoryboard.init(.entry).instantiateViewController(identifier: "AddEditEntry")
        self.present(nav, animated: true, completion: nil)
    }
#endif
    
}
