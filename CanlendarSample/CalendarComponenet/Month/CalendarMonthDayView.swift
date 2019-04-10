//
//  CalendarMonthDrawView.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 04/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class CalendarMonthDayView: UIView {

    fileprivate let paragraphStyle = NSMutableParagraphStyle()
    
    fileprivate var sundayColor = UIColor.rgb(hexValue: 0xDF4407, alpha: 0.7)
    fileprivate var saturdayColor = UIColor.rgb(hexValue: 0x4890F2, alpha: 0.7)
    fileprivate var dayRects = [CGRect]()
    fileprivate var gesture : UITapGestureRecognizer?
    
//    fileprivate let notificationName = NSNotification.Name.init("SelectedMonthDayInfo")
    fileprivate var notificationObserver : Any?
    
    var enableSelect = false {
        didSet {
            self.gesture?.isEnabled = self.enableSelect
        }
    }
    var fontColor = UIColor.black
    var monthInfo : MonthInfo? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var selectedDayInfo : DayInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.paragraphStyle.alignment = .center
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        gesture.isEnabled = false
        self.addGestureRecognizer(gesture)
        
        self.gesture = gesture
        
        self.notificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.init("SelectedMonthDayInfo"), object: nil, queue: nil) { (notification) in
            
            if self.selectedDayInfo != nil {
                self.selectedDayInfo = nil
                self.setNeedsDisplay()
            }
        }
    }
    
    deinit {
        self.notificationObserver = nil
    }
    
    @objc func onTap(_ sender:UIGestureRecognizer) {
        
        guard let days = self.monthInfo?.days else {
            return
        }
        
        if self.enableSelect == false {
            return
        }
        
        switch sender.state {
        
        case .cancelled, .ended:
            
            self.selectedDayInfo = nil
            NotificationCenter.default.post(name:NSNotification.Name.init("SelectedMonthDayInfo"), object: nil)
            
            let point = sender.location(in: self)
            
            for index in self.dayRects.enumerated() {
                
                if index.element.contains(point), days.count > index.offset {
                    self.selectedDayInfo = days[index.offset]
                    self.setNeedsDisplay()
                }
            }
            
        default:
            break
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext(), let monthInfo = self.monthInfo else {
            return
        }
        
        self.dayRects.removeAll()
        
        context.saveGState()
        
        let dayWidth = self.frame.width / 7
        let dayHeight = self.frame.height / 5
        var subRect = CGRect.zero
        
        monthInfo.days.forEach { (dayInfo) in
            
            let x = CGFloat(dayInfo.weekday).truncatingRemainder(dividingBy: 7.0) * dayWidth + 1.0
            
            let y = floor(CGFloat(dayInfo.day + monthInfo.weekdayOfFirst - 1) / 7.0) * (dayHeight)
            
            subRect.origin = CGPoint(x: x, y: y)
            subRect.size = CGSize(width: dayWidth - 2.0, height:dayHeight - 2.0)
            
            var fontSize = round(min(subRect.width, subRect.height) * 0.6)
            
            if (fontSize > 20) {
                fontSize = 20
            }
            
            let halfSize = fontSize * 1.7
            var circleRect = CGRect.zero
            circleRect.size = CGSize(width: halfSize, height: halfSize)
            circleRect.origin.x = (subRect.maxX - halfSize)
            circleRect.origin.y = (subRect.minY)
            
            if dayInfo == self.selectedDayInfo {
                context.setFillColor(UIColor.rgb(hexValue: 0x348EF8, alpha: 0.6).cgColor)
                context.fillEllipse(in: circleRect)
            } else {
                if dayInfo.isToday {
                    context.setFillColor(UIColor.rgb(hexValue: 0xcccccc, alpha: 0.6).cgColor)
                    context.fillEllipse(in: circleRect)
                }
            }
            
            circleRect.origin.y += (halfSize / 7)
            
            self.drawDayText(dayInfo:dayInfo, context:context, rect:circleRect, fontSize:fontSize)
            
            self.dayRects.append(subRect)
//            context.setStrokeColor(UIColor.green.cgColor)
//            context.stroke(subRect)
        }
        
        context.restoreGState()
    }
    
    func drawDayText(dayInfo:DayInfo, context:CGContext, rect:CGRect, fontSize:CGFloat) {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        var color = self.fontColor
        
        switch dayInfo.weekday {
        case 0:
            color = self.sundayColor
        case 6:
            color = self.saturdayColor
        default:
            break
        }
        
        let attributes = [NSAttributedString.Key.font : font
            , NSAttributedString.Key.foregroundColor : color
            , NSAttributedString.Key.paragraphStyle : self.paragraphStyle ]
        
        (String(dayInfo.day) as NSString).draw(in: rect, withAttributes: attributes)
    }
}
