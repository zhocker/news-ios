//
//  CollectionExtensionTests.swift
//  CoreTests
//
//  Created by User on 3/6/2567 BE.
//

import XCTest
@testable import Core

class CollectionExtensionTests: XCTestCase {

    func testSafeSubscriptWithinBounds() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertEqual(array[safe: 2], 3, "The safe subscript did not return the correct element.")
    }
    
    func testSafeSubscriptOutOfBounds() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertNil(array[safe: 10], "The safe subscript did not return nil for an out-of-bounds index.")
    }
    
    func testTakeSafeWithinBounds() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertEqual(array.takeSafe(index: 2), 3, "The takeSafe method did not return the correct element.")
    }
    
    func testTakeSafeOutOfBounds() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertNil(array.takeSafe(index: 10), "The takeSafe method did not return nil for an out-of-bounds index.")
    }
    
    func testIsNotEmptyTrue() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertTrue(array.isNotEmpty, "The isNotEmpty property did not return true for a non-empty collection.")
    }
    
    func testIsNotEmptyFalse() {
        let array: [Int] = []
        XCTAssertFalse(array.isNotEmpty, "The isNotEmpty property did not return false for an empty collection.")
    }
}
