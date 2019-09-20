//
//  ContactsViewModel.swift
//  GoContacts
//
//  Created by Nitin Joshi on 20/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation

struct ContactsViewModel {
    
    private let contact : Contact

    init(contact: Contact) {
        self.contact = contact
    }

    public var Name: String {
        get {
            return String("\(self.contact.firstName!) \(self.contact.lastName!)")
        }
    }
}

protocol Indexable {
    var CollationSelectorString : String {
        get
    }
}

extension ContactsViewModel : Indexable {
    var CollationSelectorString: String {
        return self.contact.firstName!
    }
}
