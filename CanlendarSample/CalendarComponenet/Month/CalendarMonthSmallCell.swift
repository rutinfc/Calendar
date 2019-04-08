//
//  CalendarDayCell.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 11/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class CalendarMonthSmallCell: UICollectionViewCell {
    
    fileprivate var monthLargeView : CalendarMonthStyleView?
    fileprivate var style : StyleMode = .center
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setting()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if layoutAttributes is CalendarTransitionAttributes {
            self.style = .leftTopEmpty
        } else {
            self.style = .center
        }
        self.checkStyle()
    }
    
    func setting() {
        
        guard let style = CalendarMonthStyleView.create(xibName: "CalendarMonthStyleView") as? CalendarMonthStyleView else {
            return
        }
        
        style.frame = self.bounds
        self.addSubview(style)
        style.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        style.backgroundColor = UIColor.white
        style.monthDayView.fontColor = UIColor.rgb(hexValue: 0x222222, alpha: 0.7)
        self.monthLargeView = style
    }
    
    func setMonth(info : MonthInfo) {
        self.monthLargeView?.monthInfo = info
    }
    
    func checkStyle() {
        if let style = self.monthLargeView?.style, style != self.style {
            self.monthLargeView?.style = self.style
        }
    }
}



