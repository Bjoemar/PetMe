//
//  GroupDataProvider.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-03-31.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import Foundation
import FirebaseFirestore

class GroupDataProvider {
    
    let db = Firestore.firestore()
    weak var delegate: GroupDataProviderDelegate?
    
    
    
    func saveInviteRequest(request: Request) {
        let ref = db.collection("requests")
        
        ref.document(request.id).setData([
            "senderID" :  request.senderID,
            "receiverUserInfo": request.receiverUserInfo,
            "senderName": request.senderName,
            "senderGroupID": request.senderGroupID,
            "requestID": request.id
        ]) { (error) in
            if error != nil {
                print("Error saving Request: \(error!)")
            }
        }
    }
    
    func getRequests(email: String) {
        var requests = [Request]()
        let query = db.collection("requests").whereField("receiverUserInfo", isEqualTo: email)
        
        query.addSnapshotListener() { (snapshot, error) in
            if error != nil {
                print("Error getting requests \(error!)")
            }
            
            
            if let documents = snapshot?.documents {
                
                requests.removeAll()
                
                for document in documents {
                    
                    let data = document.data()
                    
                    let receiverInfo = data["receiverUserInfo"] as! String
                    let senderID = data["senderID"] as! String
                    let senderName = data["senderName"] as! String
                    let senderGroupID = data["senderGroupID"] as! String
                    let requestID = data["requestID"] as! String
                    
                    let request = Request(receiverUserInfo: receiverInfo, senderID: senderID, senderName: senderName, senderGroupID: senderGroupID, id: requestID)
                    
                    requests.append(request)
                    
                }
                self.delegate?.didGetRequests?(allRequests: requests)
            }
        }
    }
    
    func getGroupMembers(groupID: String) {
        var users = [User]()
        let query = db.collection("users").whereField("groupID", isEqualTo: groupID)
        
        query.addSnapshotListener() { (snapshot, error) in
            if error != nil {
                print("Error getting group members: \(error!)")
            }
            
            if let documents = snapshot?.documents {
                users.removeAll()
                for document in documents {
                    let data = document.data()
                    
                    let email = data["email"] as! String
                    let groupID = data["groupID"] as! String
                    let name = data["name"] as! String
                    let userID = data["userID"] as! String
                    
                    let user = User(name: name, userID: userID, groupID: groupID, email: email)
                    users.append(user)
                    
                }
                self.delegate?.didGetGroupMembers?(allMembers: users)
                
            }
        }
    }
    
    func deleteRequest(id: String) {
        db.collection("requests").document(id).delete { (error) in
            if error != nil {
                print("Error deleting request: \(id) - \(error!)")
            }
        }
    }
    
    func createGroupWithOwner(user: User) {
        db.collection("groups").document(user.groupID).setData([
            "ownerID" : user.userID,
            "groupID" : user.groupID
        ]) { (error) in
            if error != nil {
                print("Error creating group with owner! \(error!)")
            }
        }
    }
    
    func isUserGroupOwner(userID: String, groupID: String) {
        let ref = db.collection("groups").whereField("groupID", isEqualTo: groupID)
        
        ref.getDocuments { (snapshot, error) in
            
            if let docs = snapshot?.documents {
                for doc in docs {
                    let data = doc.data()
                    let ownerID = data["ownerID"] as! String
                    if ownerID == userID {
                        self.delegate?.didCheckForOwner?(bool: true, ownerID: ownerID)
                    } else {
                        self.delegate?.didCheckForOwner?(bool: false, ownerID: ownerID)
                    }
                }
            }
            
        }
    }
    
    func pickNewGroupOwner(currentUserID: String, ownerID: inout String, members: [User], groupID: String) {
        while currentUserID == ownerID {
            ownerID = members.randomItem!.userID
        }
        assignNewOwner(newOwnerID: ownerID, groupID: groupID)
    }
    
    func assignNewOwner(newOwnerID: String, groupID: String) {
        let ref =  db.collection("groups").document(groupID)
        ref.updateData([
            "ownerID" : newOwnerID
        ]) { (error) in
            if error != nil {
                print("Couldn't update owner! \(error!)")
            }
            self.delegate?.didUpdateOwner?(newOwnerID: newOwnerID)
        }
        
    }
}
