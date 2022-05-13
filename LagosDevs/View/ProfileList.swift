//
//  ProfileList.swift
//  LagosDevs
//
//  Created by Yemi Gabriel on 5/9/22.
//

import UIKit

class ProfileList: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        tableView.reloadData()
    }
    
    func setUp() {
        addSubview(tableView)
        addSubview(activityIndicator)
    }
    
    func setUpConstraints() {
        let guide = safeAreaLayoutGuide
        [tableView, activityIndicator].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: guide.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 44),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }
    
    
}
