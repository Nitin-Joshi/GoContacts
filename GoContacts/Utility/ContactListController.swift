//
//  ContactListController.swift
//  GoContacts
//
//  Created by Nitin Joshi on 20/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation

class ContactListController {
    
    var sectionList: [Character]?
    var contactList: [[ContactsViewModel]]?
    
    init() {
        NetworkManager.sharedInstance.GetData(urlPath: Constants.URLConstant.ContactsPath) { (contactlist, error) in
            
        }
    }
}
