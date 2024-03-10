//
//  Profile.swift
//  Walkers
//
//  Created by Никита Васильев on 09.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let fileService: FileService
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
        addGradient()
        addViews()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        title = "Мой профиль"
        setup()
        setupAvatar()
    }
    
    // MARK: - UIElements
    
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.image = UIImage(named: "no_avatar")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        return imageView
    }()
    
    private lazy var addAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.tintColor = UIColor.systemGreen
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "add")
        return imageView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Редактировать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(edit), for: .touchUpInside)
        button.alpha = 0.8
        return button
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
    
    private let age: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Возраст:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let radius: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Радиус поиска, км:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private lazy var userName: UILabel = {
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
    
    private lazy var currentRadius: UILabel = {
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
    
    private let viewSeparate: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    
    // MARK: - Fileservice initilization
    
    init() {
        fileService = FileService()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(fileService: FileService) {
        self.fileService = fileService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Using UD
    
    let defaults = UserDefaults.standard
    
    func setup() {
        
        guard let data = UserDefaults.standard.data(forKey: .myCustomKey) else { return }
        let decoder = JSONDecoder()
        guard let user = try? decoder.decode(NewUser.self, from: data) else { return }
        
        userName.text = user.name
        userAge.text = user.age
        currentRadius.text = user.radius
        userHobbies.text = user.hobbies

    }
    
    @objc func edit() {
        let vc = ChangeUserSettings()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Get saved Avatar
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    // MARK: - Setup Avatar
    
    func setupAvatar() {
        if fileService.items.isEmpty {
            avatar.image = UIImage(named: "no_avatar")
        } else {
            if let image = getSavedImage(named: "fileName") {
                avatar.image = image
            }
        }
    }
    
    // MARK: - Tap on avatar to change a photo
    
    @objc private func tapAction() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    // MARK: - Setup layout
    
    func addViews() {
        view.addSubview(avatar)
        view.addSubview(addAvatar)
        view.addSubview(stackView)
        view.addSubview(editButton)
        stackView.addSubview(name)
        stackView.addSubview(userName)
        stackView.addSubview(age)
        stackView.addSubview(userAge)
        stackView.addSubview(radius)
        stackView.addSubview(currentRadius)
        stackView.addSubview(hobbies)
        stackView.addSubview(userHobbies)
        stackView.addSubview(viewSeparate)
    }
    
    func layout() {
        let inset: CGFloat = 150
        let inset2: CGFloat = 50
        
        NSLayoutConstraint.activate([
            
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset / 5),
            avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatar.heightAnchor.constraint(equalToConstant: inset),
            avatar.widthAnchor.constraint(equalToConstant: inset),
            
            addAvatar.bottomAnchor.constraint(equalTo: avatar.bottomAnchor, constant: -inset / 20),
            addAvatar.leadingAnchor.constraint(equalTo: avatar.leadingAnchor, constant: inset / 20),
            addAvatar.heightAnchor.constraint(equalToConstant: inset / 5),
            addAvatar.widthAnchor.constraint(equalToConstant: inset / 5),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4 * inset2),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset2 / 3),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset2 / 3),
            stackView.heightAnchor.constraint(equalToConstant: 2 * inset),
            
            editButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: inset2 / 2),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset/2),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset/2),
            
            name.topAnchor.constraint(equalTo: stackView.topAnchor, constant: inset2 / 4),
            name.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: inset2 / 2),
            name.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -inset2 / 2),
            
            userName.topAnchor.constraint(equalTo: name.topAnchor),
            userName.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant:  -inset2 / 2),
            
            age.topAnchor.constraint(equalTo: name.bottomAnchor, constant: inset2 / 2),
            age.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            age.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            userAge.topAnchor.constraint(equalTo: age.topAnchor),
            userAge.trailingAnchor.constraint(equalTo: userName.trailingAnchor),
            
            radius.topAnchor.constraint(equalTo: age.bottomAnchor, constant: inset2 / 2),
            radius.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            radius.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            currentRadius.topAnchor.constraint(equalTo: radius.topAnchor),
            currentRadius.trailingAnchor.constraint(equalTo: userName.trailingAnchor),
            
            viewSeparate.topAnchor.constraint(equalTo: radius.bottomAnchor, constant: inset2 / 2),
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
        ])
    }
}


// MARK: - Extensions

extension ProfileViewController {
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [color, UIColor.systemGray6.cgColor]
        view.layer.insertSublayer(gradient, at: 100)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            avatar.image = image
            let savedImage = fileService.saveImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
