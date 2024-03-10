//
//  CurrentUser.swift
//  Walkers
//
//  Created by Кристина on 04.12.2023.
//

import UIKit
import MapKit

class CurrentUser: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        layout()
    }
    
    private lazy var startChat: UIButton = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Написать сообщение", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(showChat), for: .touchUpInside)
        button.alpha = 0.8
        return button
    }()
    
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.image = UIImage(named: "no_avatar")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = .white
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Имя:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let gender: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пол:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let age: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Возраст:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private lazy var userGender: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private lazy var userAge: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let hobbies: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Интересы:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let userHobbies: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let phone: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Телефон:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let userPhone: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let viewSeparate: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    
    func setup(model: User) {
        userName.text = model.name.first
        userAge.text = String(model.dob.age)
        userPhone.text = "8-" + model.phone
        
        userHobbies.text = hobbiesArray.randomElement()! + ", " + hobbiesArray.randomElement()!
        
        guard let imageData = try? Data(contentsOf: model.picture.medium) else {fatalError()}
        avatar.image = UIImage(data: imageData)!
        
        guard model.gender == "female" else { return
            userGender.text = "Мужской"}
        userGender.text = "Женский"
    }
    
    @objc func showChat() {
        let vc = Chat()
        navigationController?.pushViewController(vc, animated: true)
    }

    func addViews() {
        view.addSubview(avatar)
        view.addSubview(startChat)
        view.addSubview(stackView)
        stackView.addSubview(name)
        stackView.addSubview(userName)
        stackView.addSubview(age)
        stackView.addSubview(userAge)
        stackView.addSubview(hobbies)
        stackView.addSubview(userHobbies)
        stackView.addSubview(gender)
        stackView.addSubview(userGender)
        stackView.addSubview(viewSeparate)
        stackView.addSubview(phone)
        stackView.addSubview(userPhone)
    }
    
    func layout() {
        let inset: CGFloat = 150
        let inset2: CGFloat = 50
        
        NSLayoutConstraint.activate([
            
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset / 7),
            avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatar.heightAnchor.constraint(equalToConstant: inset),
            avatar.widthAnchor.constraint(equalToConstant: inset),
            
            stackView.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: inset / 5),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset2 / 3),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset2 / 3),
            stackView.bottomAnchor.constraint(equalTo: userHobbies.bottomAnchor, constant: inset2/4),
            
            name.topAnchor.constraint(equalTo: stackView.topAnchor, constant: inset2 / 4),
            name.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: inset2 / 2),
            name.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -inset2 / 2),
            
            userName.topAnchor.constraint(equalTo: name.topAnchor),
            userName.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant:  -inset2 / 2),
            
            gender.topAnchor.constraint(equalTo: name.bottomAnchor, constant: inset2 / 2),
            gender.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            gender.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            userGender.topAnchor.constraint(equalTo: gender.topAnchor),
            userGender.trailingAnchor.constraint(equalTo: userName.trailingAnchor),
            
            age.topAnchor.constraint(equalTo: gender.bottomAnchor, constant: inset2 / 2),
            age.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            age.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            userAge.topAnchor.constraint(equalTo: age.topAnchor),
            userAge.trailingAnchor.constraint(equalTo: userName.trailingAnchor),
            
            phone.topAnchor.constraint(equalTo: age.bottomAnchor, constant: inset2 / 2),
            phone.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            phone.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            userPhone.topAnchor.constraint(equalTo: phone.topAnchor),
            userPhone.trailingAnchor.constraint(equalTo: userName.trailingAnchor),
            
            viewSeparate.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: inset2 / 2),
            viewSeparate.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            viewSeparate.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            viewSeparate.widthAnchor.constraint(equalToConstant: 100),
            viewSeparate.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            viewSeparate.heightAnchor.constraint(equalToConstant: 1),
            
            hobbies.topAnchor.constraint(equalTo: viewSeparate.bottomAnchor, constant: inset2 / 2),
            hobbies.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            hobbies.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            userHobbies.topAnchor.constraint(equalTo: hobbies.bottomAnchor, constant: inset2 / 2),
            userHobbies.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            userHobbies.trailingAnchor.constraint(equalTo: userName.trailingAnchor),
            
            startChat.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: inset2),
            startChat.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            startChat.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }

}
