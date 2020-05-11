//
//  GroupViewController.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-03-30.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit
import FirebaseAuth
import PMAlertController
import SwiftSpinner

class GroupViewController: UIViewController {
    
    weak var tableView: UITableView!
    var members = [User]()
    var provider: GroupDataProvider! = nil
    var userDataProvider: UserDataProvider! = nil
    var username = "User"
    var groupID = "id"
    var isOwner: Bool!
    var ownerID: String?
    
    
    let addMemberTextField: UITextField = {
        let textField = DefaultTextField()
        textField.placeholder = "User's Email"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let sendInviteButton: UIButton = {
        let button = DefaultButton()
        button.setTitle("Send Invite", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(sendInviteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        SwiftSpinner.show("Loading", animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider = GroupDataProvider()
        provider.delegate = self
        userDataProvider = UserDataProvider()
        userDataProvider.delegate = self
        
        if let currentUser = Auth.auth().currentUser {
            userDataProvider.getUserName(userID: currentUser.uid)
            userDataProvider.getUserGroupID(userID: currentUser.uid)
        }
        self.hideKeyboardWhenTappedAround()
        
        navigationController?.navigationBar.barTintColor = AppColors.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 20)!]
        navigationItem.title = "My Group"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(
            name: .doorOpen, style: .solid, textColor: AppColors.black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(leaveGroupButtonPressed))
        
        
        
        
        view.backgroundColor = UIColor.white
        print(groupID)
        setupViews()
        
        SwiftSpinner.hide()
        
    }
    
    
    func setupViews() {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView() // Use this to remove extra tableview separators
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(addMemberTextField)
        view.addSubview(sendInviteButton)
        
        
        view.addContraintsWithFormat(format: "V:|-\(self.topbarHeight + 50 + 5)-[v0(50)]", views: addMemberTextField)
        view.addContraintsWithFormat(format: "H:|-5-[v0]-10-[v1]-5-|", views: addMemberTextField, sendInviteButton)
        view.addContraintsWithFormat(format: "V:|-\(self.topbarHeight + 50 + 5)-[v0(50)]", views: sendInviteButton)
        
        
        
        NSLayoutConstraint.activate([
            self.addMemberTextField.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10),
            self.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor)
        ])
        
        self.tableView = tableView
        
    }
    
    @objc func sendInviteButtonPressed() {
        let receiverUserInfo = addMemberTextField.text
        if let userID =  Auth.auth().currentUser?.uid {
            if receiverUserInfo != nil && receiverUserInfo != "" {
                let newRequest = Request(receiverUserInfo:receiverUserInfo!.lowercased() , senderID: userID, senderName: username, senderGroupID: groupID, id: UUID().uuidString)
                provider.saveInviteRequest(request: newRequest)
                addMemberTextField.text = ""
            }
        }
    }
    
    @objc func leaveGroupButtonPressed() {
        showCustomAlert(title: "Are you sure?", description: "Are you sure you want to leave this group?", image:  UIImage.fontAwesomeIcon(name: .doorOpen, style: .solid, textColor: UIColor.gray, size: CGSize(width: 500, height: 500)))
    }
    
    func showCustomAlert(title: String, description: String, image: UIImage) {
        let alertVC = PMAlertController(title: title, description: description, image: image, style: .walkthrough)
        
        alertVC.alertTitle.font = AppFonts.mainFontMedium
        alertVC.alertTitle.font = alertVC.alertTitle.font.withSize(22)
        alertVC.alertTitle.textColor = AppColors.black
        
        alertVC.alertDescription.font = AppFonts.mainFontRegular
        alertVC.alertDescription.font = alertVC.alertDescription.font.withSize(18)
        
        
        
        
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("cancel pressed")
        }))
        
        let confirmAction = PMAlertAction(title: "Confirm", style: .default, action: { () in
            if let currentUser = Auth.auth().currentUser {
                if currentUser.uid == self.ownerID {
                    self.provider.pickNewGroupOwner(currentUserID: currentUser.uid, ownerID: &self.ownerID!, members: self.members, groupID: self.groupID)
                }
                self.userDataProvider.updateUserGroupID(groupToDelete: nil, newGroupID: UUID().uuidString, userID: currentUser.uid)
            }
        })
        
        confirmAction.setTitleColor(AppColors.primaryColor, for: .normal)
        
        alertVC.addAction(confirmAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    
}
