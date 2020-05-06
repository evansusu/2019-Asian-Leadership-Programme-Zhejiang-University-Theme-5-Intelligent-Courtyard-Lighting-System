//
//  LightClass.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 9/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import Foundation
import UIKit

class LightClass {
    let id: UUID
    var title: String
    var image: UIImage?
    
    init(title: String, image: UIImage? = nil){
        self.title = title
        id = UUID()
        self.image = image
    }
}
