//
//  UILabelStyleTests.swift
//  CoreTests
//
//  Created by User on 3/6/2567 BE.
//

import XCTest
import UIKit

@testable import Core

class UILabelStyleTests: XCTestCase {

    func testApplyStyleH1() {
        let label = UILabel()
        label.applyStyle(typo: .h1)
        
        XCTAssertEqual(label.font, UIFont.boldSystemFont(ofSize: 24), "H1 style font is incorrect.")
        XCTAssertEqual(label.textColor, UIColor.black, "H1 style color is incorrect.")
    }

    func testApplyStyleH2() {
        let label = UILabel()
        label.applyStyle(typo: .h2)
        
        XCTAssertEqual(label.font, UIFont.boldSystemFont(ofSize: 16), "H2 style font is incorrect.")
        XCTAssertEqual(label.textColor, UIColor.black, "H2 style color is incorrect.")
    }

    func testApplyStyleContent() {
        let label = UILabel()
        label.applyStyle(typo: .content)
        
        XCTAssertEqual(label.font, UIFont.systemFont(ofSize: 16), "Content style font is incorrect.")
        XCTAssertEqual(label.textColor, UIColor.black, "Content style color is incorrect.")
    }

    func testApplyStyleFooter() {
        let label = UILabel()
        label.applyStyle(typo: .footer)
        
        XCTAssertEqual(label.font, UIFont.systemFont(ofSize: 12), "Footer style font is incorrect.")
        XCTAssertEqual(label.textColor, UIColor.darkGray, "Footer style color is incorrect.")
    }

    func testApplyStyleButton() {
        let label = UILabel()
        label.applyStyle(typo: .button)
        
        XCTAssertEqual(label.font, UIFont.systemFont(ofSize: 14), "Button style font is incorrect.")
        XCTAssertEqual(label.textColor, UIColor.black, "Button style color is incorrect.")
    }
}
