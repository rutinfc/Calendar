//
//  CalendarDataHandler.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 21/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

protocol CalendarDataHandlerDelegate : class {
    
    func firstVisibleIndexPath() -> IndexPath?
    func scrollCurrentYear()
}

class CalendarDataHandler: NSObject {

    fileprivate var checkTimer : Timer?
    
    weak var delegate : CalendarDataHandlerDelegate?
    
    func numberOfSections() -> Int {
        return CalendarManager.instance.allYears
    }
    
    func numberOfSection(section:Int) -> Int {
        return 12
    }
    
    func indexPathOfCurrentYear() -> IndexPath {
        let yearSection = CalendarManager.instance.indexOfCurrentYear()
        return IndexPath(item: 0, section: yearSection)
    }
    
    func titleOfSection(section:Int) -> String {
        
        let info = CalendarManager.instance.yearInfo(index: section)
        
        return String(info.value)
    }
    
    func monthInfoOf(indexPath:IndexPath) -> Any {
        
        let yearInfo = CalendarManager.instance.yearInfo(index: indexPath.section)
        
        return yearInfo.months[indexPath.item]
    }
    
    func resetToday() {
        CalendarManager.instance.resetToday()
    }
    
    func checkCurrentYear() {
        
        if self.checkTimer != nil {
            self.checkTimer?.invalidate()
            self.checkTimer = nil
        }
        
        self.checkTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            
            guard let indexPath = self.delegate?.firstVisibleIndexPath() else {
                return
            }
            
            CalendarManager.instance.updateCurrentYear(index: indexPath.section) { (changed) in
                
                if changed == false {
                    return
                }
                
                self.delegate?.scrollCurrentYear()
            }
        }
    }
}
