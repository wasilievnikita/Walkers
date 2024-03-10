//
//  User.swift
//  Walkers
//
//  Created by Никита Васильев on 09.10.2023.
//

import Foundation

struct UserReslut: Decodable {
    let results: [User]   
}

struct User: Decodable {
    let name: Name
    let dob: Dob
    let picture: Picture
    let gender: String
    let phone: String
}

struct Name: Decodable {
    var first: String
}

struct Dob: Decodable {
    var age: Int
}

struct Picture: Decodable {
    var medium: URL
}

let hobbiesArray: [String] = ["Футбол", "Хоккей", "Фильмы", "Путешествия", "Еда", "Стрельба из лука","Сноуборд", "Фитнес", "Теннис", "Рисование", "Вино"]




