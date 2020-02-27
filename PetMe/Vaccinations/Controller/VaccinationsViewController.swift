//
//  VaccinationsViewController.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-02-26.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit

class VaccinationsViewController: UIViewController {
    
    var pet: Pet!
    
    let cell_id = "vaccine_cell"
    
    weak var tableView: UITableView!
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Vaccinations"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.barTintColor = AppColors.primaryColor
        view.backgroundColor = AppColors.primaryColor
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
        setupTableView()
        
         self.tableView.dataSource = self
         self.tableView.delegate = self
         self.tableView.register(VaccineTableViewCell.self, forCellReuseIdentifier: cell_id)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.barTintColor = AppColors.primaryColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        titleLabel.text = "\(pet.name)'s Vaccines"
        
        view.addContraintsWithFormat(format: "V:|[v0]", views: titleLabel)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
    }
    
    func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
               tableView.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(tableView)
               NSLayoutConstraint.activate([
                self.titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
                self.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant:  20 + (self.tabBarController?.tabBar.frame.size.height)!),
                self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: -20),
                self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 20)
               ])
        
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.tableView = tableView
    }

}
