//
//  DetailViewController.swift
//  GoContacts
//
//  Created by Nitin Joshi on 19/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import UIKit
import MessageUI

enum DetailMode {
    case Edit
    case Display
}

class DetailViewController: UIViewController {

    // UI elements ref
    @IBOutlet weak var profileImageView: CustomUIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var messageButtonView: UIView!
    @IBOutlet weak var callButtonView: UIView!
    @IBOutlet weak var emailButtonView: UIView!
    @IBOutlet weak var favButtonView: UIView!
    @IBOutlet weak var favouriteIcon: UIImageView!
    @IBOutlet weak var inputAreaTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTableView: UITableView!
    
    // privates
    private var leftBarItem: UIBarButtonItem!
    private var rightBarItem: UIBarButtonItem! // can be reused for different actions
    private var detailPageMode: DetailMode = .Display
    private var areContactDetailsChanged : Bool = false {
        didSet {
            //bind bar button with change
            if(areContactDetailsChanged) {
                rightBarItem.isEnabled = true
            }
        }
    }
    
    // UI constants
    private let inputAreaTopConstraintDeltaForEdit:CGFloat = -140
    private let animationDuration:TimeInterval = 1
    
    //input elements
    private let displayElements: [InputValue] = [.Email, .Phone]
    private let editElements: [InputValue] = [.FirstName, .LastName, .Email, .Phone]

    public var detailController: DetailsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped(_:)), tintColor:Constants.Colors.MainAppColor)
        
        rightBarItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(_:)), tintColor:Constants.Colors.MainAppColor)
        navigationItem.rightBarButtonItem = rightBarItem
                
        let messageButtonGesture = UITapGestureRecognizer(target: self, action: #selector(messageButtonTapped(_:)))
        messageButtonView.addGestureRecognizer(messageButtonGesture)
        
        let callButtonGesture = UITapGestureRecognizer(target: self, action: #selector(callButtonTapped(_:)))
        callButtonView.addGestureRecognizer(callButtonGesture)

        let emailButtonGesture = UITapGestureRecognizer(target: self, action: #selector(emailButtonTapped(_:)))
        emailButtonView.addGestureRecognizer(emailButtonGesture)

        let favButtonGesture = UITapGestureRecognizer(target: self, action: #selector(favButtonTapped(_:)))
        favButtonView.addGestureRecognizer(favButtonGesture)

        contactName.font = UIFont.boldSystemFont(ofSize: 24)
        contactName.textColor = Constants.Colors.TextColor
        
        contactName.text = detailController.contactDetail.Name
        favouriteIcon.isHighlighted = detailController.contactDetail.IsFavourite
        
        self.navigationController?.navigationBar.tintColor = Constants.Colors.MainAppColor
    }
    
    /**
     Will flip the page ui for edit or normal display mode
 */
    func flipDetailUI () {
        switch detailPageMode {
        case .Display:

            rightBarItem.title = "Edit"
            rightBarItem.isEnabled = true
            rightBarItem.action = #selector(editButtonTapped(_:))
            
            navigationItem.leftBarButtonItem = nil
            navigationItem.setHidesBackButton(false, animated: true)

            inputAreaTopConstraint.constant = 0
            contactName.text = self.detailController.contactDetail.Name

        case .Edit:
            
            rightBarItem.title = "Done"
            rightBarItem.isEnabled = false
            rightBarItem.action = #selector(doneButtonTapped(_:))

            navigationItem.setHidesBackButton(true, animated: true)
            navigationItem.setLeftBarButton(leftBarItem, animated: true)

            inputAreaTopConstraint.constant = inputAreaTopConstraintDeltaForEdit
            contactName.text = ""
        }
        
        self.inputTableView.reloadData()
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
    // MARK: - Action selector function
extension DetailViewController {
    @objc
    func editButtonTapped (_ sender: Any) {
        detailPageMode = .Edit
        
        DispatchQueue.main.async {
            self.flipDetailUI()
        }
    }
    
    @objc
    func doneButtonTapped(_ sender: Any) {
        detailPageMode = .Display
        
        //TODO save user data
        
        DispatchQueue.main.async {
            self.flipDetailUI()
        }
    }
    
    @objc
    func cancelButtonTapped (_ sender: Any) {
        if (areContactDetailsChanged) {
            DispatchQueue.main.async {
                let alertView = UIAlertController(title: nil, message: "You will lose your edits!", preferredStyle: .actionSheet)
                
                alertView.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {(alert: UIAlertAction!) in
                    DispatchQueue.main.async {
                        self.detailPageMode = .Display

                        //TODO delete temp edits from user
                        
                        self.flipDetailUI()
                    }
                }))
                
                alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alertView, animated:true)
            }
        } else {
            DispatchQueue.main.async {
                self.detailPageMode = .Display
                self.flipDetailUI()
            }
        }
    }
    
    @objc
    func messageButtonTapped (_ sender: Any) {
        if let phoneNumber = self.detailController.contactDetail.PhoneNumber, MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = self
            controller.recipients = [phoneNumber]
            
            self.present(controller, animated: true, completion: nil)
        }
        else
        {
            ShowAlertMessage(title: "Message", message: "Not able to send message!")
        }
    }
    
    @objc
    func callButtonTapped (_ sender: Any) {
        if let phoneNumber = self.detailController.contactDetail.PhoneNumber, let numberUrl = URL(string: "tel://" + phoneNumber) {
            UIApplication.shared.open(numberUrl, options: [:], completionHandler: nil)
        }
        else
        {
            ShowAlertMessage(title: "Call", message: "Not able to call!")
        }
    }
    
    @objc
    func emailButtonTapped (_ sender: Any) {
        if let email = self.detailController.contactDetail.Email, MFMailComposeViewController.canSendMail() {
            let composePicker = MFMailComposeViewController()
            composePicker.mailComposeDelegate = self
            composePicker.setToRecipients([email])
            
            self.present(composePicker, animated: true, completion: nil)
        }
        else
        {
            ShowAlertMessage(title: "Email", message: "Email not setup for this device!!")
        }
    }
    
    @objc
    func favButtonTapped (_ sender: Any) {
        favouriteIcon.isHighlighted = !favouriteIcon.isHighlighted
        self.detailController.contactDetail.IsFavourite = favouriteIcon.isHighlighted
    }
}

// MARK:- input table view delegates
extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (detailPageMode == .Edit) ? 4:2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.defaultReuseIdentifier, for: indexPath) as! DetailTableViewCell
        
        let isEditMode = (detailPageMode == .Edit)
        let element = isEditMode ? editElements[indexPath.row] : displayElements[indexPath.row]
        
        let contact = self.detailController.contactDetail
        switch element {
        case .FirstName:
            cell.SetUi(userData: contact.FirstName, inputValue: element, inputType: .Text, isEditMode: isEditMode)
        case .LastName:
            cell.SetUi(userData: contact.LastName, inputValue: element, inputType: .Text, isEditMode: isEditMode)
        case .Email:
            cell.SetUi(userData: contact.Email, inputValue: element, inputType: .Email, isEditMode: isEditMode)
        case .Phone:
            cell.SetUi(userData: contact.PhoneNumber, inputValue: element, inputType: .Number, isEditMode: isEditMode)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = (detailPageMode == .Edit) ? editElements[indexPath.row] : displayElements[indexPath.row]
        
        switch element {
        case .Email:
            emailButtonTapped(self)
        case .Phone:
            callButtonTapped(self)
        default:
            break
        }

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK:- controller delegate
extension DetailViewController: ControllerDelegate{
    func ShowAlertMessage(title:String, message: String) {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertView, animated:true)
        }
    }
    
    func ReloadTableView() {
        DispatchQueue.main.async {
            
            self.inputTableView.reloadData()
        }
    }
}

//MARK:- mail handling
extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            switch result {
            case .cancelled:
                print("Mail cancelled")
            case .saved:
                print("Mail saved")
            case .sent:
                print("Mail sent")
            case .failed:
                break
            @unknown default:
                break
        }
            
            self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- message handling
extension DetailViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
}
