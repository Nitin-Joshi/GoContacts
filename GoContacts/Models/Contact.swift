//
//  Contact.swift
//  GoContacts
//
//  Created by Nitin Joshi on 20/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation

public struct Contact {
    let id: Int
    var firstName, lastName, email, phoneNumber: String?
    var profilePic: String?
    var favourite: Bool
    var createdAt, updatedAt: String?
    var detailUrl: String?
    
    init(id: Int, favourite:Bool) {
        self.id = id
        self.favourite = favourite
    }
}

extension Contact : Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case profilePic = "profile_pic"
        case favourite = "favorite"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case detailUrl = "url"
    }
}
