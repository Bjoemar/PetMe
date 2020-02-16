//
//  DataProvider.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-02-14.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import Foundation
import Firebase

class DataManager {
    
    var db = Firestore.firestore()
    var petsRef: DocumentReference? = nil
    var user_id = ""
    var delegate: DataProviderDelegate?
    
    
    //MARK: - Get Data
    func setPetData() {
        
        var pets = [Pet]()
        
        db.collection("pets").addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            pets.removeAll()
            
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
                
                let data = document.data()
                let name = data["name"] as! String
                let age = data["age"] as! Int
                let img_name = data["img_name"] as! String
                
                let pet = Pet(name: name, imgName: img_name, created_at: Date(), age: age)
                
                
                pets.append(pet)
            }
            self.delegate?.didGetPetData(allPets: pets)
        }
    }
    
//MARK:- Push Data
    
    func addPetDataToFirestore(petToAdd pet: Pet) {
        petsRef = db.collection("pets").addDocument(data: [
            "name": pet.name,
            "img_name": pet.imgName!,
            "age": pet.age!
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(self.petsRef!.documentID)")
            }
        }
    }
}
