//
//  RecipeCellView.swift
//  Sous Box
//
//  Created by Billy on 3/20/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class RecipeCellView: UITableViewCell {

  
    @IBOutlet weak var recipePhoto: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    
    func configureCell(spoon: Spoonacular) {
        recipeTitle.text = "\(spoon.title)"
    }

}
