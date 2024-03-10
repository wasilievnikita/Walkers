//
//  SearchResult.swift
//  Walkers
//
//  Created by Никита Васильев on 09.10.2023.
//

import UIKit

class SearchResult: UIViewController {
    
    let apiController = APIController()
    var delegate: UITableViewDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addGradient()
        view.addSubview(tableView)
        layout()
        getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Результат поиска"
    }
    
    // MARK: - UIElements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewUserTableViewCell.self, forCellReuseIdentifier: NewUserTableViewCell.identifier)
        return tableView
    }()
    
    func getUser() {
        apiController.getUsers { (error) in
            if let error = error {
                NSLog("Error perfoming datatask:\(error)")
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Funcs
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Extensions

extension SearchResult: UITableViewDelegate {
}

extension SearchResult: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return apiController.users.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrentUser()
       
        let cell = tableView.dequeueReusableCell(withIdentifier: NewUserTableViewCell.identifier, for: indexPath) as! NewUserTableViewCell
        let user = apiController.users[indexPath.row]
        cell.setupCell(model: user)
        
        vc.title = "Профиль"
        vc.setup(model: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let usersCount = apiController.users.count
        let cell = tableView.dequeueReusableCell(withIdentifier: NewUserTableViewCell.identifier, for: indexPath) as! NewUserTableViewCell

        if indexPath.row < usersCount {
            let user = apiController.users[indexPath.row]
            cell.setupCell(model: user)
        }
        return cell
    }
}

extension SearchResult {
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [color, UIColor.systemGray6.cgColor]
        view.layer.insertSublayer(gradient, at: 100)
    }
}
