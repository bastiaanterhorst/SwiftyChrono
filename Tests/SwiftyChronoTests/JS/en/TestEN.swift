//
//  TestEn.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 1/23/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import XCTest
import JavaScriptCore
import SwiftyChrono

class TestEN: ChronoJSXCTestCase {
    private let files = [
        "test_en",
        "test_en_casual",
        "test_en_dash",
        "test_en_deadline",
        "test_en_inter_std",
        "test_en_little_endian",
        "test_en_middle_endian",
        "test_en_month",
        "test_en_option_forward",
        "test_en_relative",
        "test_en_slash",
        "test_en_time_ago",
        "test_en_time_exp",
        "test_en_weekday",
    ]
    
    func testExample() {
        Chrono.sixMinutesFixBefore1900 = true
        // there are few words conflict with german day keywords
        Chrono.preferredLanguage = .english
        
        for fileName in files {
            let url = Bundle.module.url(forResource: fileName, withExtension: "js", subdirectory: "Resources")
            let js = try! String(contentsOf: url!)
            evalJS(js, fileName: fileName)
        }
    }
    
    func testWeekNumbers() {
        Chrono.preferredLanguage = .english
        debugPrint("testing week")
        let c = Chrono()
        
        let now = Date()
        let startOfWeekDate = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: now).date!
        let startOfWeekNum = Calendar.current.component(.weekOfYear, from: now)
        let startOfWeekYear = Calendar.current.component(.yearForWeekOfYear, from: now)
        
        let resultA = c.parseDate(text: "week \(String(startOfWeekNum)) \(startOfWeekYear)")!
        
        // fetching the current week
        XCTAssertEqual(Calendar.current.startOfDay(for: resultA), Calendar.current.startOfDay(for: startOfWeekDate))

        // check if ISOweek is set as known value
        let resultB = c.parse(text: "week \(String(startOfWeekNum)) \(startOfWeekYear)")
        XCTAssertEqual(resultB.first?.start.knownValues[.ISOWeek], startOfWeekNum)
        
        // check last week -- this test is pretty dumb and will FAIL in the first week of the year!
        let lastWeekNum = startOfWeekNum - 1
        let resultC = c.parse(text: "week \(String(lastWeekNum))")
        // expect the year of the resulting date to be the same as the current year (a week in the past is allowed)
        XCTAssertEqual(resultC.first?.start.impliedValues[.year], startOfWeekYear)
        
        // check last week, this time setting forwardDate to 1
        let resultD = c.parse(text: "week \(String(lastWeekNum))", opt: [OptionType.forwardDate: 1])
        // expect the year of the resulting date to equal to next year
        XCTAssertEqual(resultD.first?.start.impliedValues[.year], startOfWeekYear + 1)
        
        // check various ways to refer to 'week', and different ways to include the year
        let resultE = c.parse(text: "wk \(String(startOfWeekNum)) \(startOfWeekYear)")
        XCTAssertEqual(resultE.first?.start.knownValues[.ISOWeek], startOfWeekNum)
        
        let resultEA = c.parse(text: "wk \(String(startOfWeekNum)) \(String(startOfWeekYear).suffix(2)))")
        XCTAssertEqual(resultEA.first?.start.knownValues[.ISOWeek], startOfWeekNum)
        
        let resultEB = c.parse(text: "wk \(String(startOfWeekNum)) '\(String(startOfWeekYear).suffix(2)))")
        XCTAssertEqual(resultEB.first?.start.knownValues[.ISOWeek], startOfWeekNum)
        
        // check if isoweek is set as implied value when requesting a month "June"
        let resultF = c.parse(text: "June")
        XCTAssertNotNil(resultF.first?.start.impliedValues[.ISOWeek])
        
        // check if isoweek is set as implied value when requesting relative date: "in 2 weeks/months" / "next week/month"
        let resultG = c.parse(text: "in 2 months")
        XCTAssertNotNil(resultG.first?.start.impliedValues[.ISOWeek])
        
        let resultGA = c.parse(text: "in 2 weeks")
        XCTAssertNotNil(resultGA.first?.start.impliedValues[.ISOWeek])
        
        let resultGB = c.parse(text: "next month")
        XCTAssertNotNil(resultGB.first?.start.impliedValues[.ISOWeek])
        
        let resultGC = c.parse(text: "next week")
        XCTAssertNotNil(resultGC.first?.start.impliedValues[.ISOWeek])

        let resultGD = c.parse(text: "next year")
        XCTAssertNotNil(resultGD.first?.start.impliedValues[.ISOWeek])
        
        let resultH = c.parseDate(text: "this week")
    }
}
