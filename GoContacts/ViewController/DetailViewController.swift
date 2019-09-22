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
    case Add
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
    @IBOutlet weak var cameraButton: UIButton!
    
    // privates
    private var leftBarItem: UIBarButtonItem!
    private var rightBarItem: UIBarButtonItem! // can be reused for different actions
    private var detailPageMode: DetailMode = .Display
    private var isContactModifiedInEdit : Bool = false {
        didSet {
            //bind bar button with change
            if(isContactModifiedInEdit) {
                rightBarItem.isEnabled = true
            }
        }
    }
    
    // UI constants
    private let inputAreaTopConstraintDeltaForEdit:CGFloat = -140
    
    //input elements
    private let displayElements: [InputValue] = [.Phone, .Email]
    private let editElements: [InputValue] = [.FirstName, .LastName, .Phone, .Email]

    public var detailController: DetailsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard detailController != nil else {
            return
        }
        
        if(UIDevice.current.userInterfaceIdiom == .phone) {
            leftBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped(_:)), tintColor:Constants.Colors.MainAppColor)
        }
        
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
        contactName.textColor = Constants.Colors.TextColor
        contactName.font = UIFont.boldSystemFont(ofSize: 24)

        favouriteIcon.isHighlighted = detailController.contactDetail.IsFavourite
        
        self.navigationController?.navigationBar.tintColor = Constants.Colors.MainAppColor
        
        SetDetailUIForDisplayMode(false)
    }
    
    /**
     Will flip the page ui for edit or normal display mode
 */
    func SetDetailUIForDisplayMode (_ animate: Bool) {
        switch detailPageMode {
        case .Display:

            rightBarItem.title = "Edit"
            rightBarItem.isEnabled = true
            rightBarItem.action = #selector(editButtonTapped(_:))
            
            navigationItem.leftBarButtonItem = nil
            navigationItem.setHidesBackButton(false, animated: true)

            inputAreaTopConstraint.constant = 0
            contactName.text = self.detailController.contactDetail.Name

            cameraButton.isHidden = true
            
        case .Edit, .Add:

            rightBarItem.title = "Done"
            rightBarItem.isEnabled = false
            rightBarItem.action = #selector(doneButtonTapped(_:))

            navigationItem.setHidesBackButton(true, animated: true)
            navigationItem.setLeftBarButton(leftBarItem, animated: true)

            inputAreaTopConstraint.constant = inputAreaTopConstraintDeltaForEdit
            contactName.text = ""
            
            cameraButton.isHidden = false
        }
        
        self.inputTableView.reloadData()
        
        UIView.animate(withDuration:animate ? Constants.UiConstants.AnimationDuration:0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func prepareViewForAdd () {
        detailPageMode = .Add

    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.openCameraPicker()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.openGalleryPicker()
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        self.present(alert, animated: true, completion: nil)

    }
    
}

    // MARK: - Action selector function
extension DetailViewController {
    @objc
    func editButtonTapped (_ sender: Any) {
        detailPageMode = .Edit
        
        DispatchQueue.main.async {
            self.SetDetailUIForDisplayMode(true)
        }
    }
    
    @objc
    func doneButtonTapped(_ sender: Any) {
        
        view.endEditing(true) // if keyboard is open, should take changes from editting before saving
        
        guard ValidateUserInput() else {
            return
        }
        
        self.detailController.SaveContactDetails()
        
        DispatchQueue.main.async {
            if(self.detailController.isNewContact)
            {
                self.navigationController?.navigationController?.popToRootViewController(animated: true)
            }
            else
            {
                self.detailPageMode = .Display
                self.isContactModifiedInEdit = false
                
                //reset temp data
                self.detailController.ResetTempData()
                
                self.SetDetailUIForDisplayMode(true)
            }
        }
    }
    
    @objc
    func cancelButtonTapped (_ sender: Any) {
        if (isContactModifiedInEdit) {
            DispatchQueue.main.async {
                let alertView = UIAlertController(title: nil, message: "You will lose your edits!", preferredStyle: .actionSheet)
                
                alertView.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {(alert: UIAlertAction!) in
                    DispatchQueue.main.async {
                        if(self.detailController.isNewContact)
                        {
                            self.navigationController?.navigationController?.popToRootViewController(animated: true)
                        }
                        else
                        {
                            self.detailPageMode = .Display
                            self.isContactModifiedInEdit = false
                            
                            //reset temp data
                            self.detailController.ResetTempData()
                            
                            self.SetDetailUIForDisplayMode(true)
                        }
                    }
                }))
                
                alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                switch UIDevice.current.userInterfaceIdiom {
                case .pad:
                    alertView.popoverPresentationController?.sourceView = sender as? UIView
                    alertView.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
                    alertView.popoverPresentationController?.permittedArrowDirections = .up
                default:
                    break
                }

                self.present(alertView, animated:true)
            }
        } else {
            DispatchQueue.main.async {
                if(self.detailController.isNewContact)
                {
                    self.navigationController?.navigationController?.popToRootViewController(animated: true)
                }
                else
                {
                    self.detailPageMode = .Display
                    self.SetDetailUIForDisplayMode(true)
                }
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
        self.detailController.SaveContactFavourite()
    }
    
    func ValidateUserInput () -> Bool {
        
        if self.detailController.isNewContact == true || self.detailController.tempContactFirstName != nil {
            guard let first = self.detailController.tempContactFirstName, first.count >= 2 else {
                ShowAlertMessage(title: "Error", message: "First name is too short! (minimium 2 characters)")
                return false
            }
        }
        
        if self.detailController.isNewContact == true || self.detailController.tempContactLastName != nil {
            guard let last = self.detailController.tempContactLastName, last.count >= 2 else {
                ShowAlertMessage(title: "Error", message: "Last name is too short! (minimium 2 characters)")
                return false
            }
        }
        
        if self.detailController.isNewContact == true || self.detailController.tempContactPhone != nil {
            guard let phone = self.detailController.tempContactPhone, phone.count >= 10 else {
                ShowAlertMessage(title: "Error", message: "Phone number is invalid! ")
                return false
            }
        }
        
        if self.detailController.isNewContact == true || self.detailController.tempContactEmail != nil {
            guard let email = self.detailController.tempContactEmail, isValid(email) else {
                ShowAlertMessage(title: "Error", message: "Email is invalid! ")
                return false
            }
        }
        
        return true
    }
    
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

// MARK:- input table view delegates
extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard detailController != nil else {
            return 0
        }
        return (detailPageMode == .Edit || detailPageMode == .Add) ? 4:2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.defaultReuseIdentifier, for: indexPath) as! DetailTableViewCell
        
        let isEditMode = (detailPageMode == .Edit || detailPageMode == .Add)
        let element = isEditMode ? editElements[indexPath.row] : displayElements[indexPath.row]
        
        let contact = self.detailController.contactDetail
        switch element {
        case .FirstName:
            cell.SetUi(userData: contact.FirstName ?? "", inputValue: element, inputType: .Text, isEditMode: isEditMode)
        case .LastName:
            cell.SetUi(userData: contact.LastName ?? "", inputValue: element, inputType: .Text, isEditMode: isEditMode)
        case .Email:
            cell.SetUi(userData: contact.Email ?? "", inputValue: element, inputType: .Email, isEditMode: isEditMode)
        case .Phone:
            cell.SetUi(userData: contact.PhoneNumber ?? "", inputValue: element, inputType: .Number, isEditMode: isEditMode)
        }
        
        //bind value change in edit mode
        cell.valueChanged = { inputValue, value in
            switch inputValue {
            case .FirstName:
                self.detailController.tempContactFirstName = value
            case .LastName:
                self.detailController.tempContactLastName = value
            case .Email:
                self.detailController.tempContactEmail = value
            case .Phone:
                self.detailController.tempContactPhone = value
            }

            self.isContactModifiedInEdit = true
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard detailPageMode == .Display else {
            return
        }
        
        let element =  displayElements[indexPath.row]
        
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

// MARK:- handle image picker
extension DetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCameraPicker()
    {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openGalleryPicker()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userImage = info[.editedImage] as? UIImage {
            
            //apply edited image directly to uiimageview
            profileImageView.image = userImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

