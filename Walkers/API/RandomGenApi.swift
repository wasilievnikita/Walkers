//
//  ApiController.swift
//  Walkers
//
//  Created by Никита Васильев on 09.10.2023.
//


import Foundation
import UIKit

class ApiManager {
    static let shared = ApiManager()
}
class APIController {
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&results=10")!
    typealias ComplitionHandler = (Error?) -> Void
    
    func getUsers(complition: @escaping ComplitionHandler = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error getting ueser: \(error)")
            }
            guard let data = data else {
                NSLog("No data")
                complition(nil)
                return
            }
            do {
                let newUser = try JSONDecoder().decode(UserReslut.self, from: data)
                print(newUser)
                self.users = newUser.results
            }
            catch {
                NSLog("error decoding users\(error))")
                complition(error)
            }
            complition(nil)
        }.resume()
     
    }
}

