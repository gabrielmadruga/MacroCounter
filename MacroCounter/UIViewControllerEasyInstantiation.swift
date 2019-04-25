//
//  Created by Gabriel Madruga on 4/1/18.
//  Copyright © 2018 Gabriel Madruga. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        case main
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError()
        }
        
        return viewController
    }
}

protocol StoryboardIdentifiable {
    
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable { }

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func instantiate(fromStoryboard storyboard: UIStoryboard.Storyboard) -> Self {
        return UIStoryboard(storyboard).instantiateViewController()
    }
}
