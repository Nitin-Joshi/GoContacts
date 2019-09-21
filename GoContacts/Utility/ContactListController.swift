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
    @objc optional func NavigateToDetailPageWithContact (contactId: Int, indexPath: IndexPath)
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
        let urlPath = String("\(Constants.URLConstant.ContactsPath).json")
        networkManager!.GetArrayData(urlPath: urlPath, decodingType: Contact.self) { (contacts, error) in
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
    
    /**
     Download and populate contact detail in collection
     */
    func GetContactDetail (contactId: Int, indexPath: IndexPath) {
        
        var urlPath = self.contactList[indexPath.section][indexPath.row].DetailUrl
        if (urlPath.isEmpty) {
           urlPath = String("\(Constants.URLConstant.ContactsPath)/\(contactId).json")
        }
        
        networkManager!.GetData(urlPath: urlPath, decodingType: Contact.self) { (contact, error) in
            if(error != nil)
            {
                self.controllerDelegate!.ShowAlertMessage?(message: error!)
                return
            }
            
            //Add extra details for contact to the collection
            if let contactDetail = contact {
                let contactToBeupdated = self.contactList[indexPath.section][indexPath.row]
                contactToBeupdated.UpdateExtraDetail(contactDetail: contactDetail)
                
                self.controllerDelegate!.NavigateToDetailPageWithContact?(contactId: contactId, indexPath: indexPath)
            }
        }
    }
}
