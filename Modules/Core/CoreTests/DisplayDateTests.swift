//
//  DisplayDateTests.swift
//  CoreTests
//
//  Created by User on 3/6/2567 BE.
//

import XCTest
@testable import Core

class DisplayDateTests: XCTestCase {

    func testDisplayDatePass() {
        // Test case for a valid ISO 8601 date string
        let iso8601DateString = "2023-06-03T14:25:10Z"
        let expectedDisplayDate = "3 Jun 2023"
        XCTAssertEqual(iso8601DateString.displayDate(), expectedDisplayDate, "The displayDate() method did not return the expected formatted date string.")
    }

    func testDisplayDateFail() {
        // Test case for an invalid ISO 8601 date string
        let invalidDateString = "invalid-date-string"
        let expectedDisplayDate = ""
        
        XCTAssertEqual(invalidDateString.displayDate(), expectedDisplayDate, "The displayDate() method did not return an empty string for an invalid date.")
    }

    func testDisplayDateEmptyString() {
        // Test case for an empty string
        let emptyDateString = ""
        let expectedDisplayDate = ""
        
        XCTAssertEqual(emptyDateString.displayDate(), expectedDisplayDate, "The displayDate() method did not return an empty string for an empty input.")
    }
}
