//
//  OnboardingViewController.swift
//  cancha-cliente
//
//  Created by Gabriel Madruga on 4/1/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit


protocol OnboardingViewControllerDelegate: class {
    
    func didFinish()
}

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - IBOutlets
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: Properties
    weak var delegate: OnboardingViewControllerDelegate?
    private var currentScrolledPage: Int = 0 {
        didSet {
            self.pageControl.currentPage = currentScrolledPage
        }
    }
    
    
    // MARK: - View's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupCardViews()
        finishButton.layer.borderColor = UIColor.label.cgColor
        finishButton.layer.borderWidth = 1
        finishButton.layer.cornerRadius = finishButton.bounds.height/2
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: CGFloat(numberOfPages()) * view.frame.width, height: view.frame.height)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CGFloat(numberOfPages())),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        // Brings views up
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.finishButton)
    }
    
    func numberOfPages() -> Int {
        return 3
    }
    
    func title(for page: Int) -> String {
        switch page {
        case 0:
            return "ENCUENTRA UNA CANCHA LIBRE RAPIDAMENTE"
        case 1:
            return "RESERVÁ FACILMENTE Y AL INSTANTE"
        case 2:
            return "¿TU CANCHA FAVORITA ESTA OCUPADA?"
        default:
            return ""
        }
    }
    
    func subtitle(for page: Int) -> String {
        switch page {
        case 0:
            return "Busca por zona y por fecha, no puede ser mas facil!"
        case 1:
            return "Olvidate de esas molestas llamadas por telefono"
        case 2:
            return "Recibe una notificacion cuando este disponible"
        default:
            return ""
        }
    }
    
    // MARK: - Helper methods
    
    private func setupCardViews() {
        for page in 0..<numberOfPages() {
            let card = OnboardingCardView(imageName: "onboarding\(page+1)", title: title(for: page), subtitle: subtitle(for: page))
            add(cardView: card, onPage: page)
        }

        self.pageControl.numberOfPages = self.numberOfPages()
    }
    
    private func add(cardView card: OnboardingCardView, onPage page: Int) {
        contentView.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 22),
            // Button height, button paddings, status bar, space left to look good (magic), twise the space left at the top
            card.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -60-44-100-44),
            card.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -44),
        ])
        let multiplier = 2.0 * (0.5 + CGFloat(page)) / CGFloat(numberOfPages())
        NSLayoutConstraint(item: card, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: multiplier, constant: 0).isActive = true
    }
    
    // MARK: UIScrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Update currentScrolledPage
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = Int(fractionalPage)
        if page != currentScrolledPage {
            currentScrolledPage = page
        }
    }
    
    // MARK: - IBActions
    @IBAction func onFinishButtonTouch(_ sender: Any) {
        delegate?.didFinish()
    }
}
