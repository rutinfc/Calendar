//
//  MonthInfo.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 04/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class MonthInfo: NSObject {
    
    var year : Int = 0
    var month: Int = 0
    var weekdayOfFirst : Int = 0
    var dayCount : Int = 0
    
    var days : [DayInfo]  = [DayInfo]()
    
    init(year:Int, month:Int, weekdayOfFirst:Int) {
        
        super.init()
        
        self.year = year
        self.month = month
        self.weekdayOfFirst = weekdayOfFirst
        self.dayCount = DateComponents.numberOfDays(year: year, month: month)
        
        (0..<self.dayCount).forEach { (day) in
            let weekday = (weekdayOfFirst + day % 7) % 7
            let dayInfo = DayInfo(year: year, month: month, day: day + 1, weekday:weekday)
            self.days.append(dayInfo)
        }
    }
}
