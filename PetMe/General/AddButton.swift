//
//  AddButton.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-02-24.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class AddButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = AppColors.primaryColor
        layer.cornerRadius = 30
        setImage(UIImage(named: "add")?.withTintColor(UIColor.white), for: .normal)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
