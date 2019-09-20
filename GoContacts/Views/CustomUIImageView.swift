//
//  CustomUIImageView.swift
//  GoContacts
//
//  Created by Nitin Joshi on 20/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomUIImageView : UIImageView {
    
    private let borderWidth:CGFloat = 2
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var radius = self.frame.size.width
        radius *= 0.5
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.white.cgColor
    }
}

