//
//  Utility.swift
//  GoContacts
//
//  Created by Nitin Joshi on 19/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import UIKit

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

extension UIImage {
    enum ImageIdentifier: String {
        case placeholder_photo
        case home_favourite
        case call_button, camera_button, email_button, message_button  //detail page
        case favourite_button_selected, favourite_button //contact page
    }

    /**
     Initialises and returns the image for asset image name
     */
    convenience init! (AssetImageName id:ImageIdentifier) {
        self.init(named: id.rawValue)
    }
}

extension UIColor {
    public convenience init?(hex: String, alpha: CGFloat = 1) {
        let r, g, b: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: alpha)
                    return
                }
            }
        }
        
        return nil
    }
}

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension Constants.URLConstant {
    /**
     Full backend path for contacts data
     */
    public static var ContactsPath:String {
        get {
            return String(BaseUrl + ContactsEndPoint)
        }
    }
}

extension UILocalizedIndexedCollation {
    
    /**
     Splits the array into alphabetical section sorted alphabetical
     */
    func splitAndSortArray (array:[AnyObject], collationStringSelector:Selector) -> ([AnyObject], [String]) {
        var unsortedSections = [[AnyObject]]()
        
        //Create a array to hold the data for each section
        for _ in self.sectionTitles {
            unsortedSections.append([]) //appending an empty array
        }
        
        // Populate name into sections
        for item in array {
            let index:Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        
        // Sorting the array of each sections
        var sectionTitles = [String]()
        var sections = [AnyObject]()
        for index in 0 ..< unsortedSections.count { if unsortedSections[index].count > 0 {
            sectionTitles.append(self.sectionTitles[index])
            sections.append(self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as AnyObject)
            }
        }
        
        return (sections, sectionTitles)
    }
}
