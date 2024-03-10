//
//  UserSettings.swift
//  Walkers
//
//  Created by Никита Васильев on 09.10.2023.
//

import UIKit

class UserSettings {
    
    private enum Keys: String {
        case userName
        case userAge
        case userRadius
        case userModel
    }
    
    
    static var userModel: UserModel! {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: Keys.userModel.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UserModel.self, from: savedData)
            else {
                return nil
            }
            return decodedModel
        }
        
        set {
            let defaults = UserDefaults.standard
            let key = Keys.userModel.rawValue
            
            if let userModel = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: userModel, requiringSecureCoding: false) {
                    defaults.set(savedData, forKey: key)
                }
            }
        }
    }
}



