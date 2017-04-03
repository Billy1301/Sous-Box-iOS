//
//  FirebaseClient.swift
//  Sous Box
//
//  Created by Billy on 4/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation

class FirebaseClient {
    
    var _image: String!
    var _title: String!
    var _readyInMinutes: String!
    
    
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
    
    


}
