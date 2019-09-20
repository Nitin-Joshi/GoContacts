//
//  GoContactsTests.swift
//  GoContactsTests
//
//  Created by Nitin Joshi on 19/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import XCTest
@testable import GoContacts

class GoContactsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

    // MARK: - UIColor extension
    func testUIColorExtensionForNull () {
        let whiteColor = UIColor(hex: "#FFFFFF")
        XCTAssertNotNil(whiteColor, "Color should not be null")
    }
    
    func testUIColorExtensionForNotNull () {
        let hexWithoutPrefix = UIColor(hex: "HFFFFFF")
        XCTAssertNil(hexWithoutPrefix, "Color should be null as wrong hex was provided")
        
        let hexWithWrongHexValue = UIColor(hex: "#FFFFFFF")
        XCTAssertNil(hexWithWrongHexValue, "Color should be null as wrong hex was provided")
        
        let hexWithWrongLiterals = UIColor(hex: "#ZZZZZZ")
        XCTAssertNil(hexWithWrongLiterals, "Color should be null as wrong hex was provided")
    }
    
    func testUIColorExtensionForCorrectness () {
        let convertedWhiteColorFromHex = UIColor(hex: "#FFFFFF")
        let whiteRGBColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(convertedWhiteColorFromHex , whiteRGBColor, "Color is not converted correctly from hex!")
    }
    
    //MARK: - UIImage extnesion
    func testUIImageExtensionForNull () {
        let callButtonImage = UIImage(AssetImageName: .call_button)
        XCTAssertNotNil(callButtonImage, "UIImage should not be null")
    }    
}
