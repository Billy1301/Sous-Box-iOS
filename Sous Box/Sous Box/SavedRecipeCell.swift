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
    @IBOutlet weak var recipeID: UILabel!
    
//    func configureCell(firebase: Recipe) {
//        
//        let photoURL = URL(string: "\(URL_IMAGE_BASE)" + firebase.image!)
//        savedRecipeTitle.text = firebase.title
//        savedReadyInMinutes.text = "Ready in minutes: " + firebase.readyInMinutes!
//        if firebase.image == "" {
//            savedRecipeImage.image = #imageLiteral(resourceName: "noImage")
//        } else {
//            savedRecipeImage.kf.indicatorType = .activity
//            savedRecipeImage.kf.setImage(with: photoURL)
//        }
//        recipeID.text = firebase.id! as! String
////        recipeID.text = "\(firebase.id!)"
//        
//    }
    

}
