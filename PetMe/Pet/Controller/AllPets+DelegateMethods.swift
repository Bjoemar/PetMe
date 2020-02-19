//
//  AllPets+DelegateMethods.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-02-06.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//
import UIKit
import FirebaseUI

extension AllPetsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_id , for: indexPath) as! PetCell
        
        let pet = pets[indexPath.row]
        let imgRef = provider.storageRef.child("pets/\(pet.imgName!).png")
        cell.nameLabel.text = pet.name
        
        imgRef.getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                cell.petImageView.image = UIImage(data: data!)
            }
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top, left, bottom, right
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PetProfileViewController()
        controller.pet = pets[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func didReceiveNewData(notification: Notification) {
        if let data = notification.userInfo as? [String:Pet] {
            
            let newPet = data["NewPet"]
            pets.append(newPet!)
            
            collectionView.reloadData()
        }
    }
    
}
