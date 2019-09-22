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

    weak var controllerDelegate: ControllerDelegate!

    init(_ controllerDelegate: ControllerDelegate, contact: ContactsViewModel) {
        self.controllerDelegate = controllerDelegate
        
        self.contactDetail = contact
        
        networkManager = NetworkManager()
    }
    
    func SaveContactDetails (newContactDetail: ContactsViewModel) {
        
    }
}
