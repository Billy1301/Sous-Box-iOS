//
//  SpoonClient.swift
//  Sous Box
//
//  Created by Billy on 3/21/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation
import Alamofire

class Spoonacular {
    
    //search recipe constants
    private var _title: String!
    private var _id: Int!
    private var _image: String!
    private var _imageUrls: String!
    
    //get recipe constants
    private var _originalString: String!
    private var _ingredientImage: String!
    private var _name: String!
    
    
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
    
    var ingredientImage: String {
        if _ingredientImage == nil {
            _ingredientImage = ""
        }
        return _ingredientImage
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
}
