//
//  Utility.swift
//  GoContacts
//
//  Created by Nitin Joshi on 19/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import UIKit

class Utility: NSObject {

}

extension UIBarButtonItem {
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, target: Any?, action: Selector?, tintColor:UIColor) {
        self.init(barButtonSystemItem:systemItem, target:target, action:action)
        self.tintColor = tintColor
    }
    
    public convenience init(title: String?, style: UIBarButtonItem.Style, target: Any?, action: Selector?, tintColor:UIColor) {
        self.init(title:title, style:style, target:target, action:action)
        self.tintColor = tintColor
    }
}
