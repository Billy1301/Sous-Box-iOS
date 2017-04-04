//
//  SpoonClient.swift
//  Sous Box
//
//  Created by Billy on 3/21/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation

class Spoonacular {
    
    //search recipe constants
    var _title: String!
    var _id: Int!
    var _image: String!
    var _imageUrls: String!
    var _readyInMinutes: Int!
    
    
    //get recipe constants
    var _spoonacularSourceUrl: String!
    var _originalString: String!
    
    //get instruction constants
    var _number: Int!
    var _step: String!
    
    
    var number: Int {
        if _number == nil {
            _number = 0
        }
        return _number
    }
    
    var step: String {
        if _step == nil {
            _step = ""
        }
        return _step
    }
    
    var spooncularRecipeURL: String {
        if _spoonacularSourceUrl == nil {
            _spoonacularSourceUrl = ""
        }
        return _spoonacularSourceUrl
    }
    
    var readyInMinutes: Int {
        if _readyInMinutes == nil {
            _readyInMinutes = 0
        }
        return _readyInMinutes
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
        
        if let readyInMinutes = getRecipeLists["readyInMinutes"] as? Int {
            self._readyInMinutes = readyInMinutes
        }
        
        if let imageUrls = getRecipeLists["imageUrls"] as? String {
            self._imageUrls = imageUrls
        }
    }
    
    init(getIngredients: Dictionary<String, AnyObject>) {
        
        if let originalString = getIngredients["originalString"] as? String {
            self._originalString = originalString
        }
    }
    
    init(getInstructions: Dictionary<String, AnyObject>) {
        
        if let number = getInstructions["number"] as? Int {
            self._number = number
        }
        
        if let step = getInstructions["step"] as? String {
            self._step = step
        }
    }
    
    init(getRandom: Dictionary<String, AnyObject>) {
        
        
    }
    
}
