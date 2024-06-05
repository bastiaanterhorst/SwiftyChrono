//
//  DEMonthNameLittleEndianParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 2/9/17.
//  Copyright © 2017 Potix. All rights reserved.
//


import Foundation

private let PATTERN = "(\\W|^)" +
    "(zondag|maandag|dinsdag|woensdag|donderdag|vrijdag|zaterdag|zo|ma|di|wo|do|vr|za)?\\s*" +
    "(?=\\W|$)"

private let weekdayGroup = 2

public class NLWeekdayParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .dutch }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        let lowerText = matchText.lowercased()
   
        // Weekday component
        if match.isNotEmpty(atRangeIndex: weekdayGroup) {
            let weekday = NL_WEEKDAY_OFFSET[match.string(from: text, atRangeIndex: weekdayGroup).lowercased()]!
            result.start.assign(.weekday, value: weekday)
            let components = DateComponents(weekday: weekday + 1)
            let wdDate = Calendar.current.nextDate(after: ref, matching: components, matchingPolicy: .nextTime)!
            
            result.start.imply(.day, to: wdDate.day)
            result.start.imply(.month, to: wdDate.month)
            result.start.imply(.year, to: wdDate.year)
        }
        
        result.tags[.nlMonthNameLittleEndianParser] = true
        return result
    }
}



