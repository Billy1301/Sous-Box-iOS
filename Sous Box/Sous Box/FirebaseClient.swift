//
//  FirebaseClient.swift
//  Sous Box
//
//  Created by Billy on 4/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Firebase

class Recipe: NSObject {
    var userID: String?
    var _id: Int?
    var _image: String?
    var _title: String?
    var _readyInMinutes: String?
    var _imageUrls: String?
    
    var id: Int {
        if _id == nil {
            _id = 0
        }
        return _id!
    }
    
    var image: String {
        if _image == nil {
            _image = ""
        }
        return _image!
    }
    
    var readyInMinutes: String {
        if _readyInMinutes == nil {
            _readyInMinutes = ""
        }
        return _readyInMinutes!
    }
    
    var title: String {
        if _title == nil {
            _title = ""
        }
        return _title!
    }
    
    init(dictionary: [String: AnyObject]) {
        self._id = dictionary["id"] as? Int
        self._image = dictionary["image"] as? String
        self._title = dictionary["title"] as? String
        self._readyInMinutes = dictionary["readyInMinutes"] as? String
//        self._imageUrls = dictionary["imageUrls"]?[0] as? String
    }
    
}
