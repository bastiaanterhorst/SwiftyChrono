//
//  ForwardDateRefiner.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 1/24/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

class ForwardDateRefiner: Refiner {
    override public func refine(text: String, results: [ParsedResult], opt: [OptionType: Int]) -> [ParsedResult] {
        if !opt.keys.contains(.forwardDate) && !opt.keys.contains(.forwardDate) {
            return results
        }
        
        let resultsLength = results.count
        var newResults = [ParsedResult]()
        
        var i = 0
        while i < resultsLength {
            var result = results[i]
            var refMoment = result.ref
                        
            if result.start.isCertain(component: .month) &&
                !result.start.isCertain(component: .year) && refMoment.isAfter(result.start.moment) {
                // Adjust year into the future
                for _ in 0..<3 {
                    if !refMoment.isAfter(result.start.moment) {
                        break
                    }
                    
                    result.start.imply(.year, to: result.start[.year]! + 1)
                    if result.end != nil && !result.end!.isCertain(component: .year) {
                        result.end!.imply(.year, to: result.end![.year]! + 1)
                    }
                }
                
                result.tags[.forwardDateRefiner] = true
            }
            
            if !result.start.isCertain(component: .day) && !result.start.isCertain(component: .month) &&
                !result.start.isCertain(component: .year) && result.start.isCertain(component: .weekday) &&
                refMoment.isAfter(result.start.moment)
            {
                // Adjust date to the coming week
                let weekday = result.start[.weekday]!
                refMoment = refMoment.setOrAdded(refMoment.weekday > weekday ? weekday + 7 : weekday, .weekday)
                
                result.start.imply(.day, to: refMoment.day)
                result.start.imply(.month, to: refMoment.month)
                result.start.imply(.year, to: refMoment.year)
                result.tags[.forwardDateRefiner] = true
            }
            
            // we the week year is ambiguous we need to check if we should forward refine the year
            // do this if a week is set and NO weekyear is set
            // and if the computed start date for the week with this year lies before the current week start date
            if result.start.isCertain(component: .ISOWeek) && !result.start.isCertain(component: .ISOWeekYear) {
                
                let resultWeekStart = Calendar.current.date(from: DateComponents(weekOfYear: result.start.knownValues[.ISOWeek], yearForWeekOfYear: result.start.impliedValues[.ISOWeekYear])) ?? Date.now
                
                let currentWeek = Calendar.current.component(.weekOfYear, from: Date.now)
                let currentWeekYear = Calendar.current.component(.yearForWeekOfYear, from: Date.now)
                let currentWeekStart = Calendar.current.date(from: DateComponents(weekOfYear: currentWeek, yearForWeekOfYear: currentWeekYear)) ?? Date.now
                
                if resultWeekStart < currentWeekStart {
                    let yr:Int = result.start[.ISOWeekYear] != nil ? result.start[.ISOWeekYear]! : result.start[.year] != nil ? result.start[.year]! : 2025
                    result.start.imply(.ISOWeekYear, to: yr + 1)
                    
                    // recalculate the day and month corresponding to the new weeknr/year combo
                    let components = DateComponents(weekOfYear: result.start.knownValues[.ISOWeek], yearForWeekOfYear: result.start.impliedValues[.ISOWeekYear])
                    let dateFromWeek = Calendar.current.date(from: components) ?? refMoment
                    result.start.imply(.day, to: dateFromWeek.day)
                    result.start.imply(.month, to: dateFromWeek.month)
                    result.start.imply(.year, to: dateFromWeek.year)

                    result.tags[.forwardDateRefiner] = true

                }
                
            }
            
            newResults.append(result)
            i += 1
        }

        return newResults
    }
}
