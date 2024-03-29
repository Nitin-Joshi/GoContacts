//
//  Constants.swift
//  GoContacts
//
//  Created by Nitin Joshi on 19/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import UIKit

class Constants: NSObject {

    public struct Colors {
        public static let MainAppColor                      = UIColor(hex: "#50E3C2") ?? UIColor.green
        public static let GradientMainColorWithReducedAlpha = UIColor(hex: "#50E3C2", alpha: 0.28) ?? UIColor.green
        public static let TextColor                         = UIColor(hex: "#4A4A4A") ?? UIColor.darkText
    }
    
    public struct URLConstant {
        public static let BaseUrl = "http://gojek-contacts-app.herokuapp.com"
        public static let ContactsEndPoint = "/contacts"
    }
    
    public struct UiConstants {
        public static let AnimationDuration: TimeInterval = 0.650
    }
}

@objc protocol ControllerDelegate {
    @objc optional func ShowAlertMessage (title:String, message: String)
    @objc optional func ReloadTableView ()
}
