//
//  DayInfo.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 04/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class DayInfo: NSObject {
    
    var year : Int = 0
    var month : Int = 0
    var day : Int = 0
    var weekday : Int = 0
    var isToday : Bool {
        get {
            
            let component = DateComponents.today()
            
            if component.year == self.year && component.month == month && component.day == day {
                return true
            }
            
            return false
        }
    }

    init(year:Int, month:Int, day:Int, weekday:Int) {
        
        super.init()
        self.year = year
        self.month = month
        self.day = day
        self.weekday = weekday
        
//        print("Creat : \(year) | \(month) | \(day)")
    }
    
    override var description: String {
        get {
            return "\(year) | \(month) | \(day)"
        }
    }
}
