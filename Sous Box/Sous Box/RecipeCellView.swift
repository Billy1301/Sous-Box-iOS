//
//  RecipeCellView.swift
//  Sous Box
//
//  Created by Billy on 3/20/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class RecipeCellView: UITableViewCell {

  
    @IBOutlet weak var recipePhoto: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    
    func configureCell(spoon: Spoonacular) {
        
        let photoURL = URL(string: "\(URL_IMAGE_BASE)\(spoon.image)")
        recipeTitle.text = "\(spoon.title)"
        if spoon.image == "" {
            recipePhoto.image = #imageLiteral(resourceName: "noImage")
        } else {
            recipePhoto.kf.indicatorType = .activity
            recipePhoto.kf.setImage(with: photoURL)
        }
        
    }

}
