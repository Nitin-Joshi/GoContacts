//
//  ContactsViewModel.swift
//  GoContacts
//
//  Created by Nitin Joshi on 20/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation

class ContactsViewModel {
    
    private var contact : Contact

    init(contact: Contact) {
        self.contact = contact
    }
    
    public var Id: Int {
        get {
            return self.contact.id
        }
    }

    public var Name: String {
        get {
            return String("\(self.contact.firstName!) \(self.contact.lastName!)")
        }
    }
    
    public var IsFavourite: Bool {
        set {
            self.contact.favorite = newValue
        }
        get {
            return self.contact.favorite
        }
    }
    
    public var Email: String {
        get {
            return self.contact.email!
        }
        set(email) {
            self.contact.email = email
        }
    }
    
    public var PhoneNumber: String {
        get {
            return self.contact.phoneNumber!
        }
        set(phonenumber) {
            self.contact.phoneNumber = phonenumber
        }
    }
    
    public var DetailUrl: String {
        get {
            return self.contact.detailUrl!
        }
    }
    
    public func UpdateExtraDetail (contactDetail: Contact) {
        self.contact.email = contactDetail.email!
        self.contact.phoneNumber = contactDetail.phoneNumber!
        self.contact.createdAt = contactDetail.createdAt!
        self.contact.updatedAt = contactDetail.updatedAt!
    }
}

@objc
protocol CollationIndexable {
    @objc
    var CollationSelectorString : String {
        get
    }
}

extension ContactsViewModel : CollationIndexable {
    var CollationSelectorString: String {
        return self.contact.firstName!
    }
}
