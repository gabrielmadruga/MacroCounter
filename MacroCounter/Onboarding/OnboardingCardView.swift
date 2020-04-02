//
//  OnboardingCardView.swift
//  cancha-cliente
//
//  Created by Gabriel Madruga on 4/1/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

class OnboardingCardView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    init(imageName: String, title: String, subtitle: String) {
        super.init(frame: CGRect())
        let view = loadFromNib()
        view?.layer.cornerRadius = 25.0;
//        view?.layer.shadowRadius = 8.0
//        view?.layer.shadowColor = UIColor.white.cgColor
//        view?.layer.shadowOffset = CGSize(width: 4, height: 4)
//        view?.layer.shadowOpacity = 0.10
        setup(imageName: imageName, title: title, subtitle: subtitle)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    var imageName: String = "" {
        didSet {
            imageView.image = UIImage(named: imageName)
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String = "" {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    func setup(imageName: String, title: String, subtitle: String) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
    }
}
