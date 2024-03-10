//
//  ChangeUserSettings.swift
//  Walkers
//
//  Created by Никита Васильев on 09.10.2023.
//

import Foundation
import UIKit

final class ChangeUserSettings: UIViewController {
    
    private let nc = NotificationCenter.default
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.nameTextField.delegate = self
        self.ageTextField.delegate = self
        self.radiusTextField.delegate = self
        self.hobbiesTextField.delegate = self
        layout()
    }
    
    // MARK: - UIElements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        button.alpha = 0.8
        return button
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ваше имя:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private let age: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ваш возраст:"
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
    
    private let hobbies: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ваши интересы:"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 20)
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 6
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.textAlignment = .left
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.placeholder = "Введите Ваше имя "
        return textField
    }()
    
    private lazy var ageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 20)
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 6
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.textAlignment = .left
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.placeholder = "Введите Ваш возраст"
        return textField
    }()
    
    private lazy var radiusTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 20)
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 6
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.textAlignment = .left
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.placeholder = "Введите радиус поиска"
        return textField
    }()
    
    private var hobbiesTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 20)
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 6
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.textAlignment = .left
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.placeholder = "Спорт, политика, путешествия..."
        return textField
    }()
    
    // MARK: - Funcs

    @objc func save() {
        if nameTextField.text!.isEmpty || ageTextField.text!.isEmpty || radiusTextField.text!.isEmpty  {
            showAlert()
        } else if !(radiusTextField.text!.isInt) || !(ageTextField.text!.isInt) {
            showAlertInt()
        } else {
            let encoder = JSONEncoder()
            let user = NewUser(age: ageTextField.text!, name: nameTextField.text!, radius: radiusTextField.text!, hobbies: hobbiesTextField.text!)
            guard let data = try? encoder.encode(user) else { return }
            UserDefaults.standard.set(data, forKey: .myCustomKey)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func keyboardShow(notification: NSNotification) {
        if let keyboardSize: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                    left: 0,
                                                                    bottom: keyboardSize.height,
                                                                    right: 0)
        }
    }
    
    @objc private func keyboardHide() {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        title = "Редактирование"
        nc.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func layout() {
        let inset2: CGFloat = 50
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(name)
        contentView.addSubview(nameTextField)
        contentView.addSubview(age)
        contentView.addSubview(ageTextField)
        contentView.addSubview(radius)
        contentView.addSubview(radiusTextField)
        contentView.addSubview(hobbies)
        contentView.addSubview(hobbiesTextField)
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset2 / 4),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset2 / 2),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset2 / 2),
            
            nameTextField.topAnchor.constraint(equalTo: name.bottomAnchor, constant: inset2/3),
            nameTextField.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset2 / 2),
            nameTextField.heightAnchor.constraint(equalToConstant: inset2 * 2/3),
            
            age.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: inset2/3),
            age.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            age.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            ageTextField.topAnchor.constraint(equalTo: age.bottomAnchor, constant: inset2/3 ),
            ageTextField.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            ageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset2 / 2),
            ageTextField.heightAnchor.constraint(equalToConstant: inset2 * 2/3),
            
            radius.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: inset2 / 3),
            radius.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            radius.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            radiusTextField.topAnchor.constraint(equalTo: radius.bottomAnchor, constant: inset2 / 3),
            radiusTextField.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            radiusTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset2 / 2),
            radiusTextField.heightAnchor.constraint(equalToConstant: inset2 * 2/3),
            
            hobbies.topAnchor.constraint(equalTo: radiusTextField.bottomAnchor, constant: inset2 / 3),
            hobbies.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            hobbies.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            hobbiesTextField.topAnchor.constraint(equalTo: hobbies.bottomAnchor, constant: inset2 / 3),
            hobbiesTextField.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            hobbiesTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset2 / 2),
            hobbiesTextField.heightAnchor.constraint(equalToConstant: inset2 * 1.5),
            
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset2 / 2),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset2 / 2),
            saveButton.topAnchor.constraint(equalTo: hobbiesTextField.bottomAnchor, constant: inset2),
            saveButton.heightAnchor.constraint(equalToConstant: inset2),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset2),
            
        ])
    }
    
}

// MARK: - Extensions

extension ChangeUserSettings: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChangeUserSettings {
    func showAlert() {
        let allert = UIAlertController(title: "Ошибка", message: "Не все поля заполнены", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default) {_ in
            print("Подверждение")
        }
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    func showAlertInt() {
        let allert = UIAlertController(title: "Ошибка", message: "Неверный формат данных", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default) {_ in
            print("Подверждение")
        }
        allert.addAction(okAction)
        present(allert, animated: true)
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}


