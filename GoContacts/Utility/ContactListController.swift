//
//  ContactListController.swift
//  GoContacts
//
//  Created by Nitin Joshi on 20/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation
import UIKit

 @objc protocol ControllerDelegate {
    @objc optional func ShowAlertMessage (message: String)
    @objc optional func ReloadTableView ()
}

class ContactListController {
    
    var sectionList: [String] = [String]()
    var contactList: [[ContactsViewModel]] = [[ContactsViewModel]]()
    
    weak var controllerDelegate: ControllerDelegate!
    let localeCurrentCollation: UILocalizedIndexedCollation
    let networkManager: NetworkManager!

    init(_ controllerDelegate:ControllerDelegate, _ collation: UILocalizedIndexedCollation) {
        self.controllerDelegate = controllerDelegate
        self.localeCurrentCollation = collation
        
        networkManager = NetworkManager()
        
        GetContacts()
    }
    
    /**
 Download and initialises contacts collections
 */
    func GetContacts () {
        networkManager!.GetData(urlPath: Constants.URLConstant.ContactsPath, decodingType: Contact.self) { (contacts, error) in
            if(error != nil)
            {
                self.controllerDelegate!.ShowAlertMessage?(message: error!)
                return
            }

            //Create contacts collection from array returned by network manager
            var viewModelArray = [ContactsViewModel]()
            for contact in contacts!
            {
                viewModelArray.append(ContactsViewModel(contact: contact))
            }
            
            // split the contact list into section of alphabets and sorted alphabetically
            let selector = #selector(getter: CollationIndexable.CollationSelectorString)
            let (contactArray, sectionList) = self.localeCurrentCollation.splitAndSortArray(array: viewModelArray, collationStringSelector: selector)

            self.contactList = contactArray as! [[ContactsViewModel]]
            self.sectionList = sectionList
            
            self.controllerDelegate!.ReloadTableView?()
        }
    }
}
