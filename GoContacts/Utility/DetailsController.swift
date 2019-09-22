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
    
    func SaveContactDetails () {
        
    }
    
    func ResetTempData () {
        tempContactFirstName = nil
        tempContactLastName = nil
        tempContactEmail = nil
        tempContactPhone = nil
    }
}
