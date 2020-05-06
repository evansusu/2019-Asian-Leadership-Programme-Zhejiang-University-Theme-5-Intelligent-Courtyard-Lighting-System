//
//  UIView Extensions.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 10/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit

extension UIView {
    func addShadowAndRoundedCorners() {
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.cornerRadius = 10
    }
}

