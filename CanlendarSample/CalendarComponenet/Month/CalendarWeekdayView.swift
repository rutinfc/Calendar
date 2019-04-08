//
//  CalendarWeekdayView.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 08/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class CalendarWeekdayView: UIView {

    @IBOutlet weak var leftSpace: NSLayoutConstraint!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.onOutline()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .compact {
            self.leftSpace.constant = 100
        } else if self.traitCollection.horizontalSizeClass == .compact && self.traitCollection.verticalSizeClass == .compact {
            self.leftSpace.constant = 100
        } else {
            self.leftSpace.constant = 5
        }
    }
}
