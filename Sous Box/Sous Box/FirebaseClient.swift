//
//  FirebaseClient.swift
//  Sous Box
//
//  Created by Billy on 4/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class Recipe: NSObject {
    var userID: String?
    var id: String?
    var image: String?
    var title: String?
    var readyInMinutes: String?
    var imageUrls: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.image = dictionary["image"] as? String
        self.title = dictionary["title"] as? String
        self.readyInMinutes = dictionary["readyInMinutes"] as? String
        self.imageUrls = dictionary["imageUrls"]?[0] as? String
    }
}
