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
    let firstName, lastName, email, phoneNumber: String?
    let profilePic: String?
    let favorite: Bool
    let createdAt, updatedAt: String?
    let detailUrl: String?
}

extension Contact : Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case profilePic = "profile_pic"
        case favorite
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case detailUrl = "url"
    }
}
