//
//  FileManagerService.swift
//  Walkers
//
//  Created by Никита Васильев on 25.12.2023.
//

import Foundation
import UIKit

final class FileService {
    private let pathForFolder: String
    
    var items: [String] {
        (try? FileManager.default.contentsOfDirectory(atPath: pathForFolder)) ?? []
    }
    
    init(pathForFolder: String) {
        self.pathForFolder = pathForFolder
    }
    
    init() {
        pathForFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
