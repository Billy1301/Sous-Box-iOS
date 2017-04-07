//
//  FirebaseClient.swift
//  Sous Box
//
//  Created by Billy on 4/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation

class FirebaseClient {
    
    var _id: String!
    var _image: String!
    var _title: String!
    var _readyInMinutes: String!
    
    var id: String {
        if _id == nil {
            _id = ""
        }
        return _id
    }
    
    var image: String {
        if _image == nil {
            _image = ""
        }
        return _image
    }
    
    var title: String {
        if _title == nil {
            _title = ""
        }
        return _title
    }
    
    var readyInMinutes: String {
        if _readyInMinutes == nil {
            _readyInMinutes = ""
        }
        return _readyInMinutes
    }
    
    
    init(getInfo: Dictionary<String, AnyObject>) {
        
        if let id = getInfo["id"] as? String {
            self._id = id
        }
        
        if let image = getInfo["image"] as? String {
            self._image = image
        }
        
        if let title = getInfo["title"] as? String {
            self._title = title
        }
        
        if let readyInMinutes = getInfo["readyInMinutes"] as? String {
            self._readyInMinutes = readyInMinutes
        }
        
    }

}
