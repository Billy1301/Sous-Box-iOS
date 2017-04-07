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

// search query url
let URL_SEARCH = "search?instructionsRequired=false&limitLicense=false&number=15&offset=0&query="
var URL_SEARCH_QUERY = "beef"

// example of get recipe url - grab id to input before URL_GET_RECIPE
// "479101/information?includeNutrition=false"
var URL_GET_ID = "479101"
let URL_GET_RECIPE = "/information"

// get random recipe url
let URL_GET_RANDOM = "random?limitLicense=false&number=1"

// use URL before image string object
//let URL_IMAGE_BASE: String = "https://webknox.com/recipeImages/"
let URL_IMAGE_BASE: String = "https://spoonacular.com/recipeImages/"


let API_KEY = "AgwPCi7s2gmshqMYcdLRdN9Wd2yXp1hMV3LjsnZXU7PzTroW1Z"

let HEADERS: HTTPHeaders = [
    "X-Mashape-Key": "\(API_KEY)",
//    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==\(API_KEY)",
    "Accept": "application/json"
]

let CURRENT_SEARCH_URL = URL_BASE + URL_SEARCH
let GET_RANDOM_URL = URL_BASE + URL_GET_RANDOM

typealias DownloadComplete = () -> ()
