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
    @IBOutlet weak var progressBackgroundView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewTrailingSpaceToContainer: NSLayoutConstraint!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
        self.layer.cornerRadius = 4.0;
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.20
//        progressBackgroundView.layer.shadowRadius = 4.0
//        progressBackgroundView.layer.shadowColor = UIColor.black.cgColor
//        progressBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        progressBackgroundView.layer.shadowOpacity = 0.20
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
        let progress = target != 0 ? CGFloat(current/target) : 1
        self.progressView.superview!.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.progressViewTrailingSpaceToContainer.constant = -self.progressView.superview!.bounds.size.width * progress
            self.progressView.superview!.layoutIfNeeded()
        }
        
    }
}
