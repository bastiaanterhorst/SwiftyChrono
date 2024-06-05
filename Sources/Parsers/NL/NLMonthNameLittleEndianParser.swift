//
//  DEMonthNameLittleEndianParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 2/9/17.
//  Copyright © 2017 Potix. All rights reserved.
//


import Foundation

private let PATTERN = "(\\W|^)" +
    "([0-9]{1,2})?\\s*" +
    "(\(NL_MONTH_OFFSET_PATTERN))\\s*" +
    "'?([0-9]+)?\\s*" +
    "(?=\\W|$)"

private let dateGroup = 2
private let monthNameGroup = 3
private let yearGroup = 4

public class NLMonthNameLittleEndianParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .dutch }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        let lowerText = matchText.lowercased()

        // passed a month
        if match.range(at: monthNameGroup).location != NSNotFound {
            let a = match.string(from: text, atRangeIndex: monthNameGroup).lowercased()
            let month = NL_MONTH_OFFSET[a]!
            result.start.assign(.month, value: month)
            result.start.imply(.day, to: 1)
        }
        
        // passed a day
        if match.range(at: dateGroup).location != NSNotFound {
            let day = Int(match.string(from: text, atRangeIndex: dateGroup).replacingOccurrences(of: "er", with: ""))!
            result.start.assign(.day, value: day)
        }
        
        // passed a year
        if match.range(at: yearGroup).location != NSNotFound {
            // year was passed in
            let yearNumberText = match.string(from: text, atRangeIndex: yearGroup).lowercased()
            
            // pad the year if a shorthand was passed
            let yearNumber = yearNumberText.count == 2 ? Int("20" + yearNumberText)! : Int(yearNumberText)!
            
            result.start.assign(.year, value: yearNumber)
        } else {
            // year is implied
            result.start.imply(.year, to: ref.year)
        }
         
        
        // set week if passed a month
        if match.range(at: monthNameGroup).location != NSNotFound {
            result.start.imply(.ISOWeek, to: weekNumFor(day: result.start[.day]!, month: result.start[.month]!, year: result.start[.year]!))
        }
        
        result.tags[.nlMonthNameLittleEndianParser] = true
        return result
    }
}



