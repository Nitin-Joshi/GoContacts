//
//  ContactTableViewCell.swift
//  GoContacts
//
//  Created by Nitin Joshi on 20/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation
import UIKit

class ContactTableViewCell: UITableViewCell {
    
    // UI elements ref
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var favContactIcon: UIImageView!
    
    // UI constraints ref
    @IBOutlet weak var favIconTrailingMarginConstraint: NSLayoutConstraint!

}
