//
//  DetailTableViewCell.swift
//  GoContacts
//
//  Created by Nitin Joshi on 22/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import UIKit

public enum InputType {
    case Text
    case Number
    case Email
}

public enum InputValue:String {
    case FirstName = "First Name"
    case LastName = "Last Name"
    case Email = "email"
    case Phone = "mobile"
}

class DetailTableViewCell: UITableViewCell {

    // UI elements ref
    @IBOutlet weak var inputTitle: UILabel!
    @IBOutlet weak var inputBox: UITextField!
    @IBOutlet weak var inputTitleWidthConstraint: NSLayoutConstraint!
    
    var inputType: InputType = .Text
    var isEditMode: Bool = false
    var inputValue: InputValue!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.inputType = .Text
        self.isEditMode = false
        
//        self.inputTitleWidthConstraint.isActive = false
    }

    func SetUi (userData:String, inputValue: InputValue, inputType: InputType, isEditMode:Bool) {
        self.isEditMode = isEditMode
        self.inputType = inputType
        self.inputValue = inputValue
        
        // Enable user editting for edit mode
        self.inputBox.isUserInteractionEnabled = isEditMode
        self.inputBox.text = userData

        self.inputTitle.text = inputValue.rawValue

        switch inputType {
        case .Text:
            self.inputBox.keyboardType = .default
        case .Email:
            self.inputBox.keyboardType = .emailAddress
        case .Number:
            self.inputBox.keyboardType = .numberPad
        }
        
        if(isEditMode)
        {
//            self.inputTitleWidthConstraint.isActive = true
        }
        
    }
}

extension DetailTableViewCell : ReusableView {
    
}
