//
//  DetailsController.swift
//  GoContacts
//
//  Created by Nitin Joshi on 22/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation

//@objc protocol ContactDetailsDelegate: ControllerDelegate {
//    @objc optional func NavigateToDetailPageWithContact (contactId: Int, indexPath: IndexPath)
//}

class DetailsController {
    
    var contactDetail: ContactsViewModel
    let networkManager: NetworkManager!

    var tempContactFirstName: String?
    var tempContactLastName: String?
    var tempContactEmail: String?
    var tempContactPhone: String?

    weak var controllerDelegate: ControllerDelegate!
    
    var isNewContact:Bool = false

    init(_ controllerDelegate: ControllerDelegate, contact: ContactsViewModel, isNewContact:Bool) {
        self.controllerDelegate = controllerDelegate
        
        self.contactDetail = contact
        self.isNewContact = isNewContact
        
        networkManager = NetworkManager()
    }
    
    func SaveContactFavourite () {
        let updatedContact = Contact(favourite: contactDetail.IsFavourite)
        PublishData(updatedContact, isNewContact: isNewContact)
    }
    
    func SaveContactDetails () {
        var updatedContact = Contact(favourite: contactDetail.IsFavourite)
        
        if let changedFirstName = tempContactFirstName {
            self.contactDetail.FirstName = changedFirstName
            updatedContact.firstName = changedFirstName
        }
        
        if let changedLastName = tempContactLastName {
            self.contactDetail.LastName = changedLastName
            updatedContact.lastName = changedLastName
        }
        if let changedPhone = tempContactPhone {
            self.contactDetail.PhoneNumber = changedPhone
            updatedContact.phoneNumber = changedPhone
        }
        if let changedEmail = tempContactEmail {
            self.contactDetail.Email = changedEmail
            updatedContact.email = changedEmail
        }
        
        PublishData(updatedContact, isNewContact: isNewContact)
    }
    
    private func PublishData(_ contact: Contact, isNewContact: Bool) {
        do {
            let jsonData = try JSONEncoder().encode(contact)
            print(String(data: jsonData, encoding: .utf8))
            if(isNewContact)
            {
                let urlPath = String("\(Constants.URLConstant.ContactsPath).json")
                networkManager.CreateData(urlPath: urlPath, uploadData: jsonData)
            }
            else
            {
                var urlPath = self.contactDetail.DetailUrl ?? ""
                if (urlPath.isEmpty) {
                    urlPath = String("\(Constants.URLConstant.ContactsPath)/\(self.contactDetail.Id).json")
                }
                
                networkManager.UpdateData(urlPath: urlPath, uploadData: jsonData)
            }
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
    }
    
    func ResetTempData () {
        tempContactFirstName = nil
        tempContactLastName = nil
        tempContactEmail = nil
        tempContactPhone = nil
    }
}
