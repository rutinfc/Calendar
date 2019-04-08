//
//  CalendarMonthLargeCell.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 04/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class CalendarMonthLargeCell: UICollectionViewCell {
    
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
            self.style = .centerEmpty
        } else {
            self.style = .leftTop
        }
        self.checkStyle()
    }
    
    func setting() {
        
        guard let large = CalendarMonthStyleView.create(xibName: "CalendarMonthStyleView") as? CalendarMonthStyleView else {
            return
        }
        
        large.frame = self.bounds
        self.addSubview(large)
        large.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        large.style = .leftTop
        large.monthDayView.fontColor = UIColor.rgb(hexValue: 0x222222, alpha: 0.7)
        large.backgroundColor = UIColor.white
        self.monthLargeView = large
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
