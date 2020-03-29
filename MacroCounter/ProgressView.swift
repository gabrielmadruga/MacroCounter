//
//  ProgressView.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/29/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentAndTargetLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewTrailingSpaceToContainer: NSLayoutConstraint!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    func setup(name: String, current: Float, target: Float, unit: String, color: UIColor) {
        nameLabel.text = name
        currentAndTargetLabel.text = "\(Int(round(current)))/\(Int(round(target)))"
        unitLabel.text = unit
        self.currentAndTargetLabel.textColor = color
        self.unitLabel.textColor = color
        self.progressView.backgroundColor = color
        let progress = CGFloat(current/target)
        UIView.animate(withDuration: 1) {
            self.progressViewTrailingSpaceToContainer.constant = -self.progressView.superview!.bounds.size.width * progress
            self.progressView.superview!.layoutIfNeeded()
        }
        
    }
}
