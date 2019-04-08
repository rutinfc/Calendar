//
//  CalendarDataHandler.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 11/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import Foundation

class CalendarManager {
    
    fileprivate static let cacheYear = Int(100)
    fileprivate static let startCacheIndex = Int(Float(CalendarManager.cacheYear) * 0.1)
    fileprivate static let endCacheIndex = CalendarManager.cacheYear - Int(Float(CalendarManager.cacheYear) * 0.2)
    
    static let instance = CalendarManager()
    
    static var today : Date {
        get {
            return Date()
        }
    }
    
    fileprivate var timeZone = NSTimeZone.local
    fileprivate var currentYearIndex : Int = (CalendarManager.cacheYear / 2)
    
    fileprivate var years : [Int] = Array(repeating: 0, count: CalendarManager.cacheYear)
    
    fileprivate var yearInfo : [Int:YearInfo] = [Int:YearInfo]()
    
    let calendar = Calendar(identifier: .gregorian)
    
    var currentDate = CalendarManager.today
    
    var currentYear : Int {
        get {
            return self.calendar.component(.year, from: self.currentDate)
        }
    }
    
    var allYears : Int {
        get {
            return self.years.count
        }
    }
    
    init() {
        self.contructCalendar()
    }
    
    func resetToday() {
        self.currentDate = CalendarManager.today
        self.contructCalendar()
    }
    
    func yearInfo(index:Int) -> YearInfo {
        let year = CalendarManager.instance.years[index]
        
        if let info = self.yearInfo[year] {
            return info
        }
        
        let info = YearInfo(value: year)
        self.yearInfo[year] = info
        return info
    }
    
    func indexOfCurrentYear() -> Int {
        
        guard let index = self.years.index(of:self.currentYear) else {
            return 0
        }
        
        return index
    }
    
    func updateCurrentYear(index:Int, changed:(Bool)->Void) {
        
        if self.years.count <= index {
            changed(false)
            return
        }
        
        self.currentYearIndex = index
        
        let year = self.years[index]
        
        let dateComponent = DateComponents(calendar: self.calendar, timeZone: self.timeZone, era: nil, year: year, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        guard let date = dateComponent.date else {
            changed(false)
            return
        }
        
        self.currentDate = date
        
        let range = NSRange(location: CalendarManager.startCacheIndex, length: CalendarManager.endCacheIndex)
        
        if range.contains(index) {
            changed(false)
            return
        }
        
        self.contructCalendar()
        changed(true)
    }
    
    func contructCalendar() {
        var prevYear = self.currentYear - (CalendarManager.cacheYear / 2)
        
        if prevYear < 0 {
            prevYear = 0
        }
        
        let afterYear = self.currentYear + (CalendarManager.cacheYear / 2)
        
        for index in (prevYear..<afterYear).enumerated() {
            let offset = index.offset
            let year = index.element
            self.years[offset] = year
        }
    }
    
    func debug() {
        print(self.years)
    }
}
