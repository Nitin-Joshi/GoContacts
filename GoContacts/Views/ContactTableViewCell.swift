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

    //Private variables
    private struct FavIconTrailingMargin {
        public static let Show: CGFloat = 16
        public static let Hide: CGFloat = -24
    }

    override func prepareForReuse() {
        self.favContactIcon!.image = nil
    }
    
    /**
     Configure cell UI as per data
    */
    func SetUi (profileImage: UIImage?, name: String?, isFavContact: Bool = false) {
        DispatchQueue.main.async {
            
            if(profileImage != nil) {
                self.profilePicture!.image = profileImage
            }
            else
            {
                self.profilePicture!.image = UIImage(AssetImageName: .placeholder_photo)
            }
            
            self.contactName!.text = name ?? ""
            self.contactName!.textColor = Constants.Colors.TextColor
            self.contactName!.font = UIFont.boldSystemFont(ofSize: 15)
                        
            if(isFavContact)
            {
                self.favContactIcon!.image = UIImage(AssetImageName: .home_favourite) ?? nil
                self.favIconTrailingMarginConstraint!.constant = FavIconTrailingMargin.Show
            }
            else
            {
                self.favIconTrailingMarginConstraint!.constant = FavIconTrailingMargin.Hide
            }
        }
    }
    
}

extension ContactTableViewCell : ReusableView {
    
}
