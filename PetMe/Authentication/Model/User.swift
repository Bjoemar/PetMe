//
//  User.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-03-16.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import Foundation

class User: NSObject {
    let name: String
    let userID: String
    let groupID: String
    let email: String
    
    init(name: String, userID: String, groupID: String, email: String) {
        self.name = name
        self.userID = userID
        self.groupID = groupID
        self.email = email
    }
}
