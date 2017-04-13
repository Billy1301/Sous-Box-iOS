//
//  RandomViewController.swift
//  Sous Box
//
//  Created by Billy on 4/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseAuthUI

class RandomViewController: UIViewController {
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var randomSpoon: Spoonacular!
    var randomSpoonArray = [Spoonacular]()
    var recipeInfoID: String = ""
    var recipeInfo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentReachabilityStatus != .notReachable {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RandomViewController.imageTapped(gesture:)))
            recipeImage.addGestureRecognizer(tapGesture)
            recipeImage.isUserInteractionEnabled = true
            
            self.downloadRecipeData {
//                print("Download success")
            }
        } else {
            showAlert("No network connection")
        }

    }

    
    @IBAction func likeBtnPressed(_ sender: Any) {
        let image_keywords = recipeInfo[1].replacingOccurrences(of: "https://spoonacular.com/recipeImages/", with: "")
        recipeInfo[1] = image_keywords
        print(recipeInfo)
        // need to setup 
        
    }
    
    @IBAction func dislikeBtnPressed(_ sender: Any) {
        downloadRecipeData {
            
        }
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        
        if (gesture.view as? UIImageView) != nil {
            let image_keywords = recipeInfo[1].replacingOccurrences(of: "https://spoonacular.com/recipeImages/", with: "")
            recipeInfo[1] = image_keywords
            self.performSegue(withIdentifier: "IngredientsSegue", sender: recipeInfo)
            
        }
    }
    
    func downloadRecipeData(completed: @escaping DownloadComplete) {
        
        let currentRecipeURL = URL(string: GET_RANDOM_URL)!
        
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result

            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let results = dict["recipes"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in results{
                        let recipes = Spoonacular(getRecipeLists: obj)
                        if recipes.image == "" {
                            self.recipeImage.image = #imageLiteral(resourceName: "noImage")
                        }
                        
                        let photoURL = URL(string: recipes.image)
                        self.recipeImage.kf.indicatorType = .activity
                        self.recipeImage.kf.setImage(with: photoURL)
                        self.recipeInfoID = "\(recipes.id)"
                        self.recipeTitle.text = recipes.title
                        self.recipeInfo = ["\(recipes.id)", recipes.image]
                    }
                }
            }
            completed()
        }
    }
    
    
    
    func clickedOnImage(){
        
        

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IngredientsViewController {
            destination.recipeID = recipeInfo[0]
            destination.recipePhotoUrl = recipeInfo[1]
        }
    }
}

extension UIViewController {
    func showAlert(_ error : String){
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
