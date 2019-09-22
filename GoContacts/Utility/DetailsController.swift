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

    init(_ controllerDelegate: ControllerDelegate, contact: ContactsViewModel) {
        self.controllerDelegate = controllerDelegate
        
        self.contactDetail = contact
        
        networkManager = NetworkManager()
    }
    
    func SaveContactFavourite () {
        let updatedContact = Contact(favourite: contactDetail.IsFavourite)
        PublishData(updatedContact)
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
        
        PublishData(updatedContact)
    }
    
    private func PublishData(_ contact: Contact) {
        do {
            let jsonData = try JSONEncoder().encode(contact)
            
            var urlPath = self.contactDetail.DetailUrl
            if (urlPath.isEmpty) {
                urlPath = String("\(Constants.URLConstant.ContactsPath)/\(self.contactDetail.Id).json")
            }
            
            networkManager.UpdateData(urlPath: urlPath, uploadData: jsonData)
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
