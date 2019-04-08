//
//  CalendarMonthLargeView.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 03/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

enum StyleMode {
    case none
    case leftTop
    case center
    case leftTopEmpty
    case centerEmpty
}

class CalendarMonthStyleView: UIView {
    
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var topContraints: NSLayoutConstraint!
    @IBOutlet weak var leftContraints: NSLayoutConstraint!
    
    @IBOutlet weak var vertical: NSLayoutConstraint!
    @IBOutlet weak var horizontal: NSLayoutConstraint!
    
    @IBOutlet weak var monthDayRightSpace: NSLayoutConstraint!
    @IBOutlet weak var monthDayLeftSpace: NSLayoutConstraint!
    @IBOutlet weak var monthDayTopSpace: NSLayoutConstraint!
    @IBOutlet weak var monthDayView: CalendarMonthDayView!
    
    @IBOutlet weak var lineView: UIView!
    
    var style : StyleMode = .none {
        didSet {
            self.checkStyle()
        }
    }
    
    var monthInfo : MonthInfo? {
        didSet {
            
            guard let info = self.monthInfo else {
                self.month.text = nil
                return
            }
            
            self.month.text = String(info.month)
            self.monthDayView.monthInfo = info
            self.checkStyle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.monthDayView.setNeedsDisplay()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.checkStyle()
    }
    
    func checkStyle() {
        switch self.style {
        case .leftTop:
            self.lineView.alpha = 1
            self.monthDayView.contentMode = .scaleAspectFill
            if self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .compact {
                self.monthDayTopSpace.constant = 10
                self.monthDayLeftSpace.constant = 100
            } else if self.traitCollection.horizontalSizeClass == .compact && self.traitCollection.verticalSizeClass == .compact {
                self.monthDayTopSpace.constant = 10
                self.monthDayLeftSpace.constant = 100
            } else {
                self.monthDayTopSpace.constant = 100
                self.monthDayLeftSpace.constant = 5
            }
            self.monthDayRightSpace.constant = 10
            self.month.isHidden = false
            self.topContraints.isActive = true
            self.leftContraints.isActive = true
            
            self.vertical.isActive = false
            self.horizontal.isActive = false
            self.month.font = UIFont.boldSystemFont(ofSize: 200)
            self.month.textColor = UIColor.rgb(hexValue: 0xdddddd, alpha: 0.2)
            self.month.textAlignment = .left
            self.monthDayView.alpha = 1
            
        case .center :
            self.lineView.alpha = 0
            self.monthDayView.contentMode = .scaleAspectFill
            self.monthDayRightSpace.constant = 4
            self.monthDayLeftSpace.constant = 0
            self.monthDayTopSpace.constant = 10
            self.month.isHidden = false
            self.topContraints.isActive = false
            self.leftContraints.isActive = false
            
            self.vertical.isActive = true
            self.horizontal.isActive = true
            self.month.font = UIFont.boldSystemFont(ofSize: 100)
            self.month.textColor = UIColor.rgb(hexValue: 0xcccccc, alpha: 0.2)
            self.month.textAlignment = .center
            self.monthDayView.alpha = 1
            
        case .leftTopEmpty:
            self.lineView.alpha = 1
            
            self.monthDayView.contentMode = .scaleAspectFit
            if self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .compact {
                self.monthDayTopSpace.constant = 10
                self.monthDayLeftSpace.constant = 100
            } else if self.traitCollection.horizontalSizeClass == .compact && self.traitCollection.verticalSizeClass == .compact {
                self.monthDayTopSpace.constant = 10
                self.monthDayLeftSpace.constant = 100
            } else {
                self.monthDayTopSpace.constant = 100
                self.monthDayLeftSpace.constant = 5
            }
            self.monthDayRightSpace.constant = 10
            
            self.month.isHidden = false
            self.topContraints.isActive = true
            self.leftContraints.isActive = true
            
            self.vertical.isActive = false
            self.horizontal.isActive = false
            self.month.font = UIFont.boldSystemFont(ofSize: 200)
            self.month.textColor = UIColor.rgb(hexValue: 0xdddddd, alpha: 0.4)
            self.month.textAlignment = .left
            self.monthDayView.alpha = 0
            
        case .centerEmpty :
            
            self.lineView.isHidden = true
            self.monthDayView.contentMode = .scaleAspectFit
            self.monthDayRightSpace.constant = 4
            self.monthDayLeftSpace.constant = 0
            self.monthDayTopSpace.constant = 10
            
            self.month.isHidden = false
            self.topContraints.isActive = false
            self.leftContraints.isActive = false
            
            self.vertical.isActive = true
            self.horizontal.isActive = true
            self.month.font = UIFont.boldSystemFont(ofSize: 100)
            self.month.textColor = UIColor.rgb(hexValue: 0xcccccc, alpha: 0.4)
            self.month.textAlignment = .center
            self.monthDayView.alpha = 0
            
        case .none:
            self.month.isHidden = true
        }
        
        self.layoutIfNeeded()
    }
    
}
