//
//  YearInfo.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 04/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class YearInfo: NSObject {

    var value : Int = 0
    var dayCount : Int = 0
    var weekdayOfFirstDay : Int = 0
    
    var months : [MonthInfo] = [MonthInfo]()
    var days : [DayInfo]  = [DayInfo]()
    
    init(value:Int) {
        
        super.init()
        self.value = value
        
        guard let date = DateComponents.date(year: value, month: 1, day: 1), let weekday = DateComponents.weekday(date: date) else {
            return
        }
        
        self.weekdayOfFirstDay =  weekday - 1
        
        (0..<12).forEach { (month) in
            
            let weekdayOfFirstMonth = (self.weekdayOfFirstDay + self.dayCount) % 7
            let monthInfo = MonthInfo(year: value, month: month + 1, weekdayOfFirst: weekdayOfFirstMonth)
            self.months.append(monthInfo)
            self.days += monthInfo.days
            self.dayCount += monthInfo.dayCount
        }
    }
}

