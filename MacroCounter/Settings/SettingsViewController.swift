//
//  SettingsViewController.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 8/19/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        versionLabel.text = Bundle.main.formattedVersion
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 2:
                showAppearanceSelector()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                showContactUs()
            case 1:
                print("version")
            default:
                break
            }
        default:
            break
        }
    }
    
    private func showAppearanceSelector() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "System", style: .default, handler: { [unowned self] (action) in
            if let window = self.view.window, window.overrideUserInterfaceStyle != .unspecified {
                UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.overrideUserInterfaceStyle = .unspecified
                }, completion: nil)
                UserDefaults.standard.userInterfaceStyle = .unspecified
            }
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Light", style: .default, handler: { [unowned self] (action) in
            if let window = self.view.window, window.overrideUserInterfaceStyle != .light {
                UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.overrideUserInterfaceStyle = .light
                }, completion: nil)
                UserDefaults.standard.userInterfaceStyle = .light
            }
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Dark", style: .default, handler: { [unowned self] (action) in
            if let window = self.view.window, window.overrideUserInterfaceStyle != .dark {
                UIView.transition (with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.overrideUserInterfaceStyle = .dark
                }, completion: nil)
                UserDefaults.standard.userInterfaceStyle = .dark
            }
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }

    private func showContactUs() {
        let email = "gabriel@madruga.com"
        let alert = UIAlertController(title: "Contact US", message: "Please send an email to \(email)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Copy Email Address", style: .default, handler: { (action) in
            UIPasteboard.general.string = email
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
