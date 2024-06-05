//
//  DEDeadlineFormatParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 2/8/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

private let PATTERN = "(\\W|^)" +
"(in|over)\\s*" +
"(\(NL_INTEGER_WORDS_PATTERN)|[0-9]+)\\s*" +
"(seconde|seconden|minuut|minuten|uur|uren|dag|dagen|week|weken|maand|maanden|jaar|jaren)\\s*" +
"(?=\\W|$)"



public class NLDeadlineFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .dutch }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        result.tags[.nlDeadlineFormatParser] = true
        
        let number: Int
        let numberText = match.string(from: text, atRangeIndex: 3).lowercased()
        if let number0 = NL_INTEGER_WORDS[numberText] {
            number = number0
        } else {
            number = Int(numberText)!
        }

        var date = ref
        let matchText4 = match.string(from: text, atRangeIndex: 4)
        func ymdResult() -> ParsedResult {
            result.start.assign(.year, value: date.year)
            result.start.assign(.month, value: date.month)
            result.start.assign(.day, value: date.day)
            return result
        }
        if NSRegularExpression.isMatch(forPattern: "dag|dagen", in: matchText4) {
            date = date.added(number, .day)
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "week|weken", in: matchText4) {
            date = date.added(number * 7, .day)
            result.start.imply(.ISOWeek, to: weekNumFor(day: date.day, month: date.month, year: date.year))
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "maand|maanden", in: matchText4) {
            date = date.added(number, .month)
            result.start.imply(.ISOWeek, to: weekNumFor(day: date.day, month: date.month, year: date.year))
            return ymdResult()
        } else if NSRegularExpression.isMatch(forPattern: "jaar|jaren", in: matchText4) {
            date = date.added(number, .year)
            result.start.imply(.ISOWeek, to: weekNumFor(day: date.day, month: date.month, year: date.year))
            return ymdResult()
        }
        
        
        
        if NSRegularExpression.isMatch(forPattern: "uur|uren", in: matchText4) {
            date = date.added(Int(number), .hour)
        } else if NSRegularExpression.isMatch(forPattern: "minuut|minuten", in: matchText4) {
            date = date.added(Int(number), .minute)
        } else if NSRegularExpression.isMatch(forPattern: "seconde|seconden", in: matchText4) {
            date = date.added(Int(number), .second)
        }
        
        result.start.imply(.year, to: date.year)
        result.start.imply(.month, to: date.month)
        result.start.imply(.day, to: date.day)
        result.start.assign(.hour, value: date.hour)
        result.start.assign(.minute, value: date.minute)
        result.start.assign(.second, value: date.second)
        
        return result
    }
}


