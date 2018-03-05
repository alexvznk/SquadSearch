//
//  Storyboard+Utility.swift
//  SquadSearch
//
//  Created by swallis on 3/5/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

extension UIStoryboard {
    //Allow us to segue between storyboards more easily
    enum SSType: String {
        case main
        case login

        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: SSType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: SSType) -> UIViewController {
        let storyboard = UIStoryboard(type: type, bundle: .main)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        return initialViewController
    }
    
    static func viewController(for type: SSType, identifier id: String) -> UIViewController {
        let storyboard = UIStoryboard(type: type, bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: id)
        
        return viewController
    }
}
