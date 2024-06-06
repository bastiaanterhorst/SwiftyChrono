//
//  File.swift
//
//
//  Created by Bastiaan Terhorst on 03/06/2024.
//

import Foundation

private let PATTERN = "(\\W|^)" +
"(this week)\\s*" +
"(?=\\W|$)"

public class ENThisWeekParser: Parser {
    override var pattern: String { return PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)

        let refMoment = ref
        var startMoment = refMoment
        let lowerText = matchText.lowercased()
        
        let week = Calendar.current.component(.weekOfYear, from: refMoment)
        let year = Calendar.current.component(.yearForWeekOfYear, from: refMoment)

        result.start.assign(.ISOWeek, value: week)
        result.start.assign(.year, value: year)
        
        let components = DateComponents(weekOfYear: week, yearForWeekOfYear: year)
        let dateFromWeek = Calendar.current.date(from: components) ?? ref
        
        result.start.imply(.day, to: dateFromWeek.day)
        result.start.imply(.month, to: dateFromWeek.month)

        result.tags[.enCasualDateParser] = true
        return result
    }
}
