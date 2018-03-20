//
//  MultilineLabel.swift
//  SquadSearch
//
//  Created by Alex on 3/19/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

class MultilineLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        preferredMaxLayoutWidth = bounds.width
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        super.layoutSubviews()
        
    }
}
