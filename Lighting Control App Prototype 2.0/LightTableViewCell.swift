//
//  LightTableViewCell.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 10/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit

//Creating a custom Cell Class
class LightTableViewCell: UITableViewCell {

    // Referencing the cell view as cardview
    @IBOutlet weak var cardView: UIView!
    //Referencing the cell label as lightTitleLabel
    @IBOutlet weak var lightTitleLabel: UILabel!
    //Referencing the cell image as lightImgae
    @IBOutlet weak var lightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization Code
        //Changing the shadow of the cellview and giving a corner radius
        cardView.addShadowAndRoundedCorners()
        lightImage.layer.cornerRadius = cardView.layer.cornerRadius
    }
    
    //creating a function to change the title of the custom cell
    //The func takes in the LightClass class and extracts data from it
    func setup(LightName: String, LightImage: UIImage?) {
        //Label of the custom cell would be the title of the lightclass
        lightTitleLabel.text = LightName
        if LightImage != nil {
            lightImage.image = LightImage
        }
    }
}
