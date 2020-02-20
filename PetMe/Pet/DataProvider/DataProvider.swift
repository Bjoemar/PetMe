//
//  DataProvider.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-02-14.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class DataManager {
    
    var db = Firestore.firestore()
    var petsRef: DocumentReference? = nil
    var delegate: DataProviderDelegate?
    var storageRef = Storage.storage().reference()
    
    
    
    //MARK: - Get Data
    func setPetData() {
        
        var pets = [Pet]()
        
        let ref = db.collection("pets").order(by: "name")
        
        ref.addSnapshotListener { (querySnapshot, error) in
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
    
    
    //MARK: - Push Data
    
    
    func addPetDataToFirebase(data: Data?, img_name: String, petToAdd pet: Pet) {
        // Just save the data if user doesn't provide me a photo
        if img_name == "placeholder" {
            petsRef = self.db.collection("pets").addDocument(data: [
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
        } else {
            // Only saving the rest of the data after the image is for sure at the storage, to avoid not being to get the image on the collectionView
            let imgRef = storageRef.child("pets/\(img_name)")
            imgRef.putData(data!, metadata: nil) { (metadata, error ) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    self.petsRef = self.db.collection("pets").addDocument(data: [
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
        }
        
    }
    
    func getPetImage(from pet: Pet, to imageView: UIImageView) {
        let imgRef = storageRef.child("pets/\(pet.imgName!)")
        
        
        imgRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                let img = UIImage(data: data!)
                self.delegate?.didLoadImage(image: img!, reference: imageView)
            }
        }
    }
}
