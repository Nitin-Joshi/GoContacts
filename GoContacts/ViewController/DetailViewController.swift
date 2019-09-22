//
//  DetailViewController.swift
//  GoContacts
//
//  Created by Nitin Joshi on 19/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import UIKit

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
    
    // private
    private var leftBarItem: UIBarButtonItem!
    private var rightBarItem: UIBarButtonItem!
    private var detailPageMode: DetailMode = .Display
    private var areContactDetailsChanged : Bool = false
    
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
            rightBarItem.action = #selector(editButtonTapped(_:))
            
            navigationItem.leftBarButtonItem = nil
            navigationItem.setHidesBackButton(false, animated: true)

            contactName.text = self.detailController.contactDetail.Name

        case .Edit:
            
            rightBarItem.title = "Done"
            rightBarItem.action = #selector(doneButtonTapped(_:))

            navigationItem.setHidesBackButton(true, animated: true)
            navigationItem.setLeftBarButton(leftBarItem, animated: true)

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
        
    }
    
    @objc
    func callButtonTapped (_ sender: Any) {
        
    }
    
    @objc
    func emailButtonTapped (_ sender: Any) {
        
    }
    
    @objc
    func favButtonTapped (_ sender: Any) {
        self.detailController.contactDetail.IsFavourite = favouriteIcon.isHighlighted
    }
}
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
