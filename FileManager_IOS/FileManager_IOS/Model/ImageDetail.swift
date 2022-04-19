//
//  ImageDetail.swift
//  FileManager_IOS
//
//  Created by Pham Van Thai on 14/04/2022.
//

import Foundation
import UIKit

struct ImageDetail {
    var name: String
    var resolution: String
    var image: UIImage
    
    init(name: String, resolution: String, image: UIImage) {
        self.name = name
        self.resolution = resolution
        self.image = image
    }
}
