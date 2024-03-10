//
//  AllChats.swift
//  Walkers
//
//  Created by Никита Васильев on 11.02.2024.
//

import UIKit
//
//class MyChats: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        layout()
//        title = "Чаты"
//
//    }
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.showsVerticalScrollIndicator = false
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(NewUserTableViewCell.self, forCellReuseIdentifier: NewUserTableViewCell.identifier)
//        return tableView
//    }()
//    
//    // MARK: - Funcs
//    
//    private func layout() {
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//    }
//
//}
//
//// MARK: - Extensions
//
//extension MyChats: UITableViewDelegate {
//}
//
//extension MyChats: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return apiController.users.count
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = CurrentChat()
//       
//        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! NewUserTableViewCell
//        let chat =
//        cell.setupCell(model: user)
//        
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       
//        let usersCount = apiController.users.count
//        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! ChatTableViewCell
//
//        
//            cell.setupCell(model: user)
//
//        return cell
//    }
//}
