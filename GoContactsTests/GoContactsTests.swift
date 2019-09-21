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

    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
    }

    override func tearDown() {
        networkManager = nil
        
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
    
    // MARK:- Network mangaer
    func testGetDataWithWrongUrl () {
        let wrongUrlPath = "http://www.googlemmmmm.co.in"
        networkManager!.GetData(urlPath: wrongUrlPath, decodingType: Contact.self) { (contacts, error) in
            
            XCTAssertNotNil(error, "Function is not able to handle wrong URl!!")
        }
    }
    
}
