//
//  DECasualDateParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 2/7/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

private let PATTERN = "(\\W|^)(nu|vandaag|(?:morgen|gisteren))(?=\\W|$)"

public class NLCasualDateParser: Parser {
    override var pattern: String { return PATTERN }
    override var language: Language { return .dutch }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        let refMoment = ref
        var startMoment = refMoment
        let lowerText = matchText.lowercased()
        
        if NSRegularExpression.isMatch(forPattern: "^morgen", in: lowerText) {
            // Check not "Tomorrow" on late night
            if refMoment.hour > 1 {
                startMoment = startMoment.added(1, .day)
            }
        } else if NSRegularExpression.isMatch(forPattern: "^gisteren", in: lowerText) {
            startMoment = startMoment.added(-1, .day)
        } else if NSRegularExpression.isMatch(forPattern: "nu", in: lowerText) {
            result.start.imply(.hour, to: refMoment.hour)
            result.start.imply(.minute, to: refMoment.minute)
            result.start.imply(.second, to: refMoment.second)
            result.start.imply(.millisecond, to: refMoment.millisecond)
        }
        
        result.start.assign(.day, value: startMoment.day)
        result.start.assign(.month, value: startMoment.month)
        result.start.assign(.year, value: startMoment.year)
        result.tags[.nlCasualDateParser] = true
        return result
    }
}

