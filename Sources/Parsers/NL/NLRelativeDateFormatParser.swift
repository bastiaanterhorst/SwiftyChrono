//
//  ENRelativeDateFormatParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 1/23/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

private let PATTERN = "(\\W|^)" +
    "(volgende|vorig|vorige)\\s*" +
    "(\(NL_INTEGER_WORDS_PATTERN)|[0-9]+(?:\\s*an?)?)?\\s*" +
    "(dag|dagen|week|weken|maand|maanden|jaar|jaren)?\\s*" +
    "(?=\\W|$)"

private let modifierWordGroup = 2
private let multiplierWordGroup = 3
private let relativeWordGroup = 4

public class NLRelativeDateFormatParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .dutch }

    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        let modifier = match.isNotEmpty(atRangeIndex: modifierWordGroup) && NSRegularExpression.isMatch(forPattern: "^volgende", in: match.string(from: text, atRangeIndex: modifierWordGroup).lowercased()) ? 1 : -1
        result.tags[.enRelativeDateFormatParser] = true
        
        var number = 1

        number *= modifier
        
        var date = ref
        if match.isNotEmpty(atRangeIndex: relativeWordGroup) {
            let relativeWord = match.string(from: text, atRangeIndex: relativeWordGroup)
            
            if NSRegularExpression.isMatch(forPattern: "dag|dagen", in: relativeWord) {
                date = date.added(number, .day)
                result.start.assign(.year, value: date.year)
                result.start.assign(.month, value: date.month)
                result.start.assign(.day, value: date.day)
            } else if NSRegularExpression.isMatch(forPattern: "week|weken", in: relativeWord) {
                date = date.added(number * 7, .day)
                // We don't know the exact date for next/last week so we imply
                // them
                result.start.imply(.day, to: date.day)
                result.start.imply(.month, to: date.month)
                result.start.imply(.year, to: date.year)
                result.start.imply(.ISOWeek, to: weekNumFor(day: date.day, month: date.month, year: date.year))
            } else if NSRegularExpression.isMatch(forPattern: "maand|maanden", in: relativeWord) {
                date = date.added(number * 1, .month)
                // We don't know the exact day for next/last month, set to first
                result.start.imply(.day, to: 1)
                result.start.assign(.year, value: date.year)
                result.start.assign(.month, value: date.month)
                result.start.imply(.ISOWeek, to: weekNumFor(day: date.day, month: date.month, year: date.year))
            } else if NSRegularExpression.isMatch(forPattern: "jaar|jaren", in: relativeWord) {
                date = date.added(number, .year)
                // We don't know the exact day for month on next/last year
                result.start.imply(.day, to: date.day)
                result.start.imply(.month, to: date.month)
                result.start.assign(.year, value: date.year)
                result.start.imply(.ISOWeek, to: weekNumFor(day: date.day, month: date.month, year: date.year))
            }
            
            return result
        }
        

        result.start.assign(.year, value: date.year)
        result.start.assign(.month, value: date.month)
        result.start.assign(.day, value: date.day)
        return result
    }
}
