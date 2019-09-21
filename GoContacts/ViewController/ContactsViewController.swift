//
//  ContactsViewController.swift
//  GoContacts
//
//  Created by Nitin Joshi on 19/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    //Private variables
    private let PageTitle : String = "Contact"
    
    var contactListController: ContactListController!
    
    var detailViewController: DetailViewController? = nil
    let spinner = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let localeCurrentCollation = UILocalizedIndexedCollation.current()
                
        let groupButton = UIBarButtonItem(title: "Groups", style: .plain, target: self, action: nil, tintColor:Constants.Colors.MainAppColor)
        navigationItem.leftBarButtonItem = groupButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewContact(_:)), tintColor:Constants.Colors.MainAppColor)
        navigationItem.rightBarButtonItem = addButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        ShowSpinner()
        
        contactListController = ContactListController(self, localeCurrentCollation)
                
        navigationItem.title = PageTitle
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewContact(_ sender: Any) {

    }
}

// MARK: - Segues
extension ContactsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                let contact = self.contactListController.contactList[indexPath.section][indexPath.row]
                controller.contactDetail = contact
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let contact = contactListController!.contactList[indexPath.section][indexPath.row]
                contactListController.GetContactDetail(contactId: contact.Id, indexPath: indexPath)
                ShowSpinner()
            }
        }
        
        return false
    }
}

// MARK: - Table View Data Source and Delegate
extension ContactsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactListController!.sectionList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactListController!.contactList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.defaultReuseIdentifier, for: indexPath) as! ContactTableViewCell

        let contact = contactListController!.contactList[indexPath.section][indexPath.row]
        
        cell.SetUi(profileImage: nil, name: contact.Name, isFavContact: contact.IsFavourite)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactListController!.sectionList[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactListController!.sectionList
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
}

// MARK: - Helper controller delegates
extension ContactsViewController: ControllerDelegate {
    
    func ShowAlertMessage(message: String) {
        DispatchQueue.main.async {
            self.HideSpinner()
            let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertView, animated:true)
        }
    }
    
    func ReloadTableView() {
        DispatchQueue.main.async {
            self.HideSpinner()
            self.tableView.reloadData()
        }
    }
    
    func NavigateToDetailPageWithContact(contactId: Int, indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.HideSpinner()
            self.performSegue(withIdentifier: "showDetail", sender: nil)
        }
    }
}
//MARK:- Activity spinner
extension ContactsViewController {
    
    func ShowSpinner() {
        
        spinner.style = .whiteLarge
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = Constants.Colors.MainAppColor
        self.tableView.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        spinner.startAnimating()
    }
    
    func HideSpinner () {
        spinner.removeFromSuperview()
        spinner.stopAnimating()
    }
}
