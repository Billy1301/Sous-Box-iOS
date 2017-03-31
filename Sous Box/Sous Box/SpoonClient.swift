//
//  SpoonClient.swift
//  Sous Box
//
//  Created by Billy on 3/21/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher

class Spoonacular {
    
    //search recipe constants
    var _title: String!
    var _id: Int!
    var _image: String!
    var _imageUrls: String!
    
    
    //get recipe constants
    var _spoonacularSourceUrl: String!
    var _originalString: String!
    var _name: String!
    
    
    var spooncularRecipeURL: String {
        if _spoonacularSourceUrl == nil {
            _spoonacularSourceUrl = ""
        }
        return _spoonacularSourceUrl
    }
    
    var title: String {
        if _title == nil {
            _title = ""
        }
        return _title
    }
    
    var id: Int {
        if _id == nil {
            _id = 0
        }
        return _id
    }

    
    var image: String {
        if _image == nil {
            _image = ""
        }
        return _image
    }
    
    var imageUrls: String {
        if _imageUrls == nil {
            _imageUrls = ""
        }
        return _imageUrls
    }
    
    var originalString: String {
        if _originalString == nil {
            _originalString = ""
        }
        return _originalString
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    init(getRecipeLists: Dictionary<String, AnyObject>) {
        
            if let id = getRecipeLists["id"] as? Int {
                self._id = id
            }
                    
            if let title = getRecipeLists["title"] as? String {
                self._title = title
            }
                    
            if let image = getRecipeLists["image"] as? String {
                self._image = image
            }
        
            if let imageUrls = getRecipeLists["imageUrls"] as? String {
                self._imageUrls = imageUrls
            }
    }
    
    init(getIngredients: Dictionary<String, AnyObject>) {
        
    }
    
}
