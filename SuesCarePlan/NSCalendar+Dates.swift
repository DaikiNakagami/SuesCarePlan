//
//  NSCalendar+Dates.swift
//  SuesCarePlan
//
//  Created by Graham Barker on 21/07/2016.
//  Copyright © 2016 Graham Barker. All rights reserved.
//

import Foundation

extension NSCalendar {
    /**
     Returns a tuple containing the start and end dates for the week that the
     specified date falls in.
     */
    func weekDatesForDate(date: NSDate) -> (start: NSDate, end: NSDate) {
        var interval: NSTimeInterval = 0
        var start: NSDate?
        rangeOfUnit(.WeekOfYear, startDate: &start, interval: &interval, forDate: date)
        let end = start!.dateByAddingTimeInterval(interval)
        
        return (start!, end)
    }
}
