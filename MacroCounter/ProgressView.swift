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
    @IBOutlet weak var progressView: UIProgressView!
    
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
        func capedRatioTo1(_ value: Float, _ goalValue: Float) -> Float {
            let ratio = value / goalValue
            return ratio > 1 ? 1 : ratio
        }
        progressView.setProgress(capedRatioTo1(current, target), animated: true)
        
        currentAndTargetLabel.textColor = color
        unitLabel.textColor = color
        progressView.tintColor = color
    }
}
