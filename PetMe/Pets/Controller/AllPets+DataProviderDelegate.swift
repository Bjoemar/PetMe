//
//  AllPets+DataProviderDelegate.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-02-14.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

extension AllPetsController: DataProviderDelegate {
    func didLoadImage(image: UIImage, reference: UIImageView) {
        let resizedImg = image.circle
        reference.image = resizedImg
        //        SwiftSpinner.hide()
    }
    
    
    func didGetPetData(allPets: [Pet]) {
        pets = allPets
        collectionView.reloadData()
        //        SwiftSpinner.hide()
    }
    
    func didGetPetDataTest() {
        self.collectionView.reloadData()
        
    }
}
