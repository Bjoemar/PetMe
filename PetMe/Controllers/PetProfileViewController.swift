//
//  PetProfileViewController.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-02-05.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class PetProfileViewController: UIViewController {
    
    weak var collectionView: UICollectionView!
    
    let cell_id = "button_cell_id"
    
    var pet: Pet!
    
    let topContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.primaryColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        
        
        return view
    }()
    
    let bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.backgroundColor
        
        return view
    }()
    
    let petAvatarPic: UIImageView = PetAvatarWithBorderImageView()
    
    let petNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Pet Name"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.barTintColor = AppColors.backgroundColor
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        // apple default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCollectionView()
        
        self.navigationController?.navigationBar.barTintColor = AppColors.primaryColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.collectionView.register(ProfileButtonCollectionViewCell.self, forCellWithReuseIdentifier: cell_id)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        
    }
    
    func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomContainer.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.topContainer.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
            self.bottomContainer.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.bottomContainer.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.bottomContainer.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ])
        
        self.collectionView = collectionView
        
        //Customize collectionView from here:
        
        self.collectionView.backgroundColor = AppColors.backgroundColor
        
    }
    
    func setupViews() {
        
        view.backgroundColor = AppColors.backgroundColor
        view.addSubview(topContainer)
        view.addSubview(bottomContainer)
        
        topContainer.addSubview(petAvatarPic)
        topContainer.addSubview(petNameLabel)
        
        
        
        petAvatarPic.image = UIImage(named: pet.imgName ?? "preto") // need to change this later
        
        petNameLabel.text = pet.name!
        
        view.addContraintsWithFormat(format: "H:|[v0]|", views: topContainer)
        view.addContraintsWithFormat(format: "V:|[v0(250)][v1]|", views: topContainer, bottomContainer)
        
        view.addContraintsWithFormat(format: "H:|[v0]|", views: bottomContainer)
        
        topContainer.addContraintsWithFormat(format: "H:[v0(150)]", views: petAvatarPic)
        topContainer.addContraintsWithFormat(format: "V:|-30-[v0(150)]-15-[v1]", views: petAvatarPic, petNameLabel)
        topContainer.addContraintsWithFormat(format: "H:|[v0]|", views: petNameLabel)
        
        
        
        //        topContainer.addConstraint(NSLayoutConstraint(item: petAvatarPic, attribute: .centerY, relatedBy: .equal, toItem: topContainer, attribute: .centerY, multiplier: 1, constant: 0))
        //
        topContainer.addConstraint(NSLayoutConstraint(item: petAvatarPic, attribute: .centerX, relatedBy: .equal, toItem: topContainer, attribute: .centerX, multiplier: 1, constant: 0))
        
    }
}
