//
//  GroupVC+GroupDataProviderDelegateMethods.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-04-06.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import Foundation

extension GroupViewController: GroupDataProviderDelegate {
    func didGetGroupMembers(allMembers: [User]) {
        members = allMembers
        tableView.reloadData()
    }
    
    func didCheckForOwner(bool: Bool) {
        isOwner = bool
        self.tableView.reloadData()
    }
}
