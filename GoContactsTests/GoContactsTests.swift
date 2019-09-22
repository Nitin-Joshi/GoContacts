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
    var viewController: ContactsViewController!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController

    }

    override func tearDown() {
        networkManager = nil
        viewController = nil
        
        super.tearDown()
    }

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
    
    // MARK:- Extensions
    func testdefaultReuseIdentifierNotNull () {
        var celldefaultId = DetailTableViewCell.defaultReuseIdentifier
        XCTAssertNotNil(celldefaultId, "reusable identifier should not be null!!")
        
        celldefaultId = ContactTableViewCell.defaultReuseIdentifier
        XCTAssertNotNil(celldefaultId, "reusable identifier should not be null!!")

    }
    
    func testsplitAndSortArrayNotNull () {
        
        viewController.contactListController = ContactListController(viewController.self, UILocalizedIndexedCollation.current())
        
        let mockContactArray = [ContactsViewModel(contact: Contact(id: 1, firstName: "apple", lastName: nil, email: nil, phoneNumber: nil, profilePic: nil, favorite: false, createdAt: nil, updatedAt: nil, detailUrl: nil)),
                                ContactsViewModel(contact: Contact(id: 1, firstName: "ball", lastName: nil, email: nil, phoneNumber: nil, profilePic: nil, favorite: false, createdAt: nil, updatedAt: nil, detailUrl: nil))]
        
        let selector = #selector(getter: CollationIndexable.CollationSelectorString)
        let (contactArray, sectionList) = UILocalizedIndexedCollation.current().splitAndSortArray(array: mockContactArray as [AnyObject], collationStringSelector: selector)
        
        XCTAssertNotNil(contactArray, "Array should not be null!!")
        XCTAssertNotNil(sectionList, "Array should not be null!!")
        
        XCTAssertEqual(sectionList.count, 2, "Array is not partitioned properly!!")
        XCTAssertEqual(contactArray.count, 2, "Array is not partitioned properly!!")
        XCTAssertEqual(contactArray[0].count, 1, "Array is not partitioned properly!!")
        XCTAssertEqual(contactArray[1].count, 1, "Array is not partitioned properly!!")
    }

    func testGetReusableStringNotNull () {
        var celldefaultId = DetailTableViewCell.defaultReuseIdentifier
        XCTAssertNotNil(celldefaultId, "reusable identifier should not be null!!")
        
        celldefaultId = ContactTableViewCell.defaultReuseIdentifier
        XCTAssertNotNil(celldefaultId, "reusable identifier should not be null!!")
        
    }

}
