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
    private var _title: String!
    private var _id: Int!
    private var _readyInMinutes: Int!
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
    
    var readyInMinutes: Int {
        if _readyInMinutes == nil {
            _readyInMinutes = 0
        }
        return _readyInMinutes
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
    
    
    func downloadRecipeData(completed: @escaping DownloadComplete) {
        
        let currentRecipeURL = URL(string: CURRENT_SEARCH_URL)!
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
            
//            print(response)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
            
                if let results = dict["results"] as? Dictionary<String, AnyObject> {
                    
                    if let id = results["id"] as? Int {
                        self._id = id
                    }
                    
                    if let title = results["title"] as? String {
                        self._title = title
                    }
                    
                    if let image = results["image"] as? String {
                        self._image = image
                    }
                    
                    if let readyInMinutes = results["readyInMinutes"] as? Int {
                        self._readyInMinutes = readyInMinutes
                    }
                    
                }
            }
        }
        
        completed()
        
    }
    
    
    func getRecipeIngredients(completed: @escaping DownloadComplete) {
        
        let getRecipeURL = URL(string: GET_RECIPE_URL)!
        Alamofire.request(getRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
            print(response)
        }
        
    }
    
    
}
