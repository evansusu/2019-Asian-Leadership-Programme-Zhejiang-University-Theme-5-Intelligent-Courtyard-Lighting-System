//
//  LightFunctions.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 9/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import Foundation

class LightFunctions {
    
    static func createLight(LightClass: LightClass) {
        dataClass.lightdata.append(LightClass)
    }
    
    static func readLight(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            if dataClass.lightdata.count == 0 {
                dataClass.lightdata.append(LightClass(title: "Test Light 1"))
                dataClass.lightdata.append(LightClass(title: "Test Light 2"))
                dataClass.lightdata.append(LightClass(title: "Test Light 3"))
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    static func updateLight(LightClass: LightClass) {
        
    }
    
    static func deleteLight(LightClass: LightClass) {
        
    }
}
