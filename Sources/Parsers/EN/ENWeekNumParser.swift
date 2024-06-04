//
//  File.swift
//  
//
//  Created by Bastiaan Terhorst on 03/06/2024.
//

import Foundation

//private let PATTERN = "(\\W|^)" +
//"(week|wk)\\s*" +
//"(\(EN_INTEGER_WORDS_PATTERN)|[0-9]){1}\\s*" +
//"(\(EN_INTEGER_WORDS_PATTERN)|[0-9])?\\s*" +
//"(?=\\W|$)"

private let PATTERN = "(\\W|^)" +
"(week|wk)\\s*" +
"([0-9]+)\\s*" +
"'?([0-9]+)?\\s*" +
"(?=\\W|$)"

//private let PATTERN = "^week|wk\\s*(\\d+)\\s*(\\d+)?"

public class ENWeekNumParser: Parser {
    override var pattern: String { return PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        let refMoment = ref
        var startMoment = refMoment
        let lowerText = matchText.lowercased()

        // parse week number
        let weekNumberText = match.string(from: text, atRangeIndex: 3).lowercased()
        let weekNumber = Int(weekNumberText)!
        result.start.assign(.ISOWeek, value: weekNumber)
        
        let yearNumber:Int
        if match.range(at: 4).location != NSNotFound {
            // year was passed in
            let yearNumberText = match.string(from: text, atRangeIndex: 4).lowercased()
            
            // pad the year if a shorthand was passed
            yearNumber = yearNumberText.count == 2 ? Int("20" + yearNumberText)! : Int(yearNumberText)!
            
            result.start.assign(.year, value: yearNumber)
        } else {
            // year is implied
            yearNumber = ref.year
            result.start.imply(.year, to: yearNumber)
        }
        
        // now calculate the actual date of the start of the week, so we can set the implied day and month
        let components = DateComponents(weekOfYear: weekNumber, yearForWeekOfYear: yearNumber)
        let dateFromWeek = Calendar.current.date(from: components) ?? ref
        
        result.start.imply(.day, to: dateFromWeek.day)
        result.start.imply(.month, to: dateFromWeek.month)
        
        
        // TODO: set implied values for month and day based on the known or implied year
        // do this by calculating the date for the week
        
        result.tags[.enCasualDateParser] = true
        return result
    }
}
