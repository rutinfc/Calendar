//
//  DateComponentsExtension.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 05/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import Foundation

extension DateComponents {
    
    static func components(year:Int, month:Int, day:Int) -> DateComponents {
        
        var comp = DateComponents()
        
        comp.year = year
        comp.month = month
        comp.day = day
        
        return comp
    }
    
    static func today() -> DateComponents {
        return CalendarManager().calendar.dateComponents([.year, .month, .day], from: CalendarManager.today)
    }
    
    static func date(year:Int, month:Int, day:Int) -> Date? {
        
        return CalendarManager().calendar.date(from: self.components(year: year, month: month, day: day))
    }
    
    static func weekday(date:Date) -> Int? {
        let comp = CalendarManager().calendar.dateComponents([.weekday], from: date)
        return comp.weekday
    }
    
    static func numberOfDays(year:Int, month:Int) -> Int {
        guard let date = self.date(year: year, month: month, day: 1) else {
            return 0
        }
        
        guard let range = CalendarManager().calendar.range(of: .day, in: .month, for: date) else {
            return 0
        }
        
        return range.lowerBound.distance(to: range.upperBound)
    }
}
