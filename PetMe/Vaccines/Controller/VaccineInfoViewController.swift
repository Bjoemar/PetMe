//
//  VaccineInfoViewController.swift
//  PetMe
//
//  Created by Lucas Rocha on 2020-03-02.
//  Copyright © 2020 Lucas Rocha. All rights reserved.
//

import UIKit
import RLBAlertsPickers

class VaccineInfoViewController: UIViewController {
    
    var vaccine: Vaccine!
    
    weak var tableView: UITableView!
    
    var provider: VaccinesDataProvider!
    
    let cell_id = "vaccineInfo_Cell"
    
    var dateSelected: Date?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Vaccine"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = AppColors.primaryColor
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.provider = VaccinesDataProvider()
        view.backgroundColor = AppColors.primaryColor
        setupViews()
        setupTableView()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(VaccineInfoTableViewCell.self, forCellReuseIdentifier: cell_id)
        
        self.tableView.tableFooterView = UIView() // Remove extra lines from table view
        
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        titleLabel.text = "\(vaccine.name)"
        
        view.addContraintsWithFormat(format: "V:|[v0]", views: titleLabel)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
    }
    
    func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        
        
        NSLayoutConstraint.activate([
            self.titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
            self.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor)
        ])
        
        self.tableView = tableView
        tableView.backgroundColor = UIColor.white
        
    }
    
    @objc func switchButtonValueChanged(mySwitch: UISwitch) {
        if mySwitch.isOn == true {
            showAlertWithPicker()
        } else {
            self.dateSelected = nil
            provider.updateData(isTaken: false, date: nil, id: vaccine.id!)
            self.tableView.reloadData()
        }
    }
    
    func showAlertWithPicker() {
        let alert = UIAlertController()
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: Date()) { date in
            
            self.dateSelected = date
            
        }
        
        alert.addAction(UIAlertAction(title: "Select Date", style: .default, handler: { (_ action) in
            
            if self.dateSelected == nil {
                self.dateSelected = Date()
            }
            self.provider.updateData(isTaken: true, date: self.dateSelected!, id: self.vaccine.id!)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.show()
        
        
        
    }
    
}

