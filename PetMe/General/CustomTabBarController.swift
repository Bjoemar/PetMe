//
//  CustomTabBarController.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-01-29.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let layout = UICollectionViewFlowLayout()
        let allPetsController = AllPetsController()
        let allPetsNavController = UINavigationController(rootViewController: allPetsController)
        let remindersController = RemindersViewController()
        let remindersNavController = UINavigationController(rootViewController: remindersController)
        remindersController.tabBarItem.title = "Reminders"
        remindersController.tabBarItem.image = UIImage.fontAwesomeIcon(name: .listAlt, style: .regular, textColor: AppColors.black, size: CGSize(width: 35, height: 35))
        allPetsController.tabBarItem.title = "My pets"
        allPetsController.tabBarItem.image = UIImage.fontAwesomeIcon(name: .paw, style: .solid, textColor: AppColors.black, size: CGSize(width: 35, height: 35))
        tabBar.tintColor = AppColors.black
        
        
        viewControllers = [allPetsNavController, remindersNavController]
        
    }
    
    private func createNavControllerWithTitle(title: String, imgName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imgName)
        
        return navController
    }

}
