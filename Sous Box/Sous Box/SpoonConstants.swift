//
//  SpoonConstants.swift
//  Sous Box
//
//  Created by Billy on 3/20/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation
import Alamofire


let URL_BASE = "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/"
let URL_SEARCH = "search?instructionsRequired=false&limitLicense=false&number=100&offset=0&query=\(URL_SEARCH_QUERY)"
var URL_SEARCH_QUERY = "beef"

let URL_GET_RECIPE = "\(URL_GET_ID)/information?includeNutrition=false"
var URL_GET_ID = "479101"

let URL_IMAGE_BASE = "https://webknox.com/recipeImages/"


let API_KEY = "AgwPCi7s2gmshqMYcdLRdN9Wd2yXp1hMV3LjsnZXU7PzTroW1Z"
let headers: HTTPHeaders = [
    "X-Mashape-Key": "\(API_KEY)",
//    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==\(API_KEY)",
    "Accept": "application/json"
]

typealias DownloadComplete = () -> ()
