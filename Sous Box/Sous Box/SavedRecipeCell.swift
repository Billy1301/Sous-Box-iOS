//
//  SavedRecipeCell.swift
//  Sous Box
//
//  Created by Billy on 3/20/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class SavedRecipeCell: UITableViewCell {


    @IBOutlet weak var savedRecipeImage: UIImageView!
    @IBOutlet weak var savedRecipeTitle: UILabel!
    @IBOutlet weak var savedReadyInMinutes: UILabel!
    
    
    func configureCell(spoon: Spoonacular) {
        
        let photoURL = URL(string: "\(URL_IMAGE_BASE)"+spoon.image)
        savedRecipeTitle.text = spoon.title
        savedReadyInMinutes.text = "Ready in minutes: \(spoon._readyInMinutes!)"
        if spoon.image == "" {
            savedRecipeImage.image = #imageLiteral(resourceName: "noImage")
        } else {
            savedRecipeImage.kf.indicatorType = .activity
            savedRecipeImage.kf.setImage(with: photoURL)
        }
        
    }
    

}
