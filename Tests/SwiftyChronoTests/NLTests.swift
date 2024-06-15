//
//  NLTests.swift
//  
//
//  Created by Bastiaan Terhorst on 05/06/2024.
//

import XCTest
import SwiftyChrono

final class NLTests: XCTestCase {

    var c:Chrono = Chrono()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Chrono.preferredLanguage = .dutch
        c = Chrono()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCasual() throws {
        let now = Calendar.current.startOfDay(for: Date())
        
        //NLCasualDateParser
//        // today
//        let resultA = c.parseDate(text: "vandaag")
//        XCTAssertEqual(now, Calendar.current.startOfDay(for: resultA!))
//        // tomorrow
//        let resultB = c.parseDate(text: "morgen")
//        let tomorrow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: now)!)
//        XCTAssertEqual(tomorrow, Calendar.current.startOfDay(for: resultB!))
        
        //NLDeadlineParser
//        debugPrint(c.parse(text: "in 2 dagen"))
        debugPrint(c.parse(text: "over 2 weken"))
//        debugPrint(c.parseDate(text: "in 2 maanden"))
//        debugPrint(c.parseDate(text: "in 2 jaar"))
//        debugPrint(c.parse("in 2 weken"), c.parseDate(text: "in 2 weken"))
//        debugPrint(c.parse("over 2 dagen"), c.parseDate(text: "over 2 dagen"))
//        debugPrint(c.parse("in drie jaar"), c.parseDate(text: "in drie jaar"))
//        debugPrint(c.parse("in 20 seconden"), c.parseDate(text: "in 20 seconden"))
//        debugPrint(c.parse("in 30 minuten"), c.parseDate(text: "in 30 minuten"))
//        debugPrint(c.parse("in 4 uur"), c.parseDate(text: "in 4 uur"))
        
        //NLMonthLittleEndianParser
//        debugPrint(c.parse("oktober"), c.parseDate(text: "oktober"))
//        debugPrint(c.parse("23 oktober"), c.parseDate(text: "23 oktober"))
//        debugPrint(c.parse("op maandag"), c.parseDate(text: "op maandag"))
//        debugPrint(c.parse("in augustus"), c.parseDate(text: "in augustus"))
//        debugPrint(c.parse("mei 2026"), c.parseDate(text: "mei 2026"))
//        
//        NLWeekdayParser
//        debugPrint(c.parse("zondag"), c.parseDate(text: "zondag"))
//        debugPrint(c.parse("woensdag"), c.parseDate(text: "woensdag"))
//        
        //NLRelativeDateFormatParser
//        debugPrint(c.parse("volgende week"), c.parseDate(text: "volgende week"))
//        debugPrint(c.parse("volgende maand"), c.parseDate(text: "volgende maand"))
//        debugPrint(c.parse("vorig jaar"), c.parseDate(text: "vorig jaar"))
        
//        let resultH = c.parse(text: "deze week")
//        debugPrint(resultH)

    }
    
    

}
