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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadRecipeData {
//            print(self.randomSpoon.id)
        }
    }

    
    @IBAction func likeBtnPressed(_ sender: Any) {
        print(recipeInfoID)
    }
    
    @IBAction func dislikeBtnPressed(_ sender: Any) {
    
    }
    
    func downloadRecipeData(completed: @escaping DownloadComplete) {
        
        let currentRecipeURL = URL(string: GET_RANDOM_URL)!
        
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
//            print(response)
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let results = dict["recipes"] as? [Dictionary<String, AnyObject>] {
//                    print(results)
                    
                    for obj in results{
                        let recipes = Spoonacular(getRecipeLists: obj)
                        let photoURL = URL(string: recipes.image)
                        self.recipeImage.kf.indicatorType = .activity
                        self.recipeImage.kf.setImage(with: photoURL)
                        self.recipeInfoID = "\(recipes.id)"
                        self.recipeTitle.text = recipes.title
                    }
                }
            }
            completed()
        }
    }
    
    func clickedOnImage(){
        recipeInfoID = "\(randomSpoon.id)"
        self.performSegue(withIdentifier: "IngredientsSegue", sender: recipeInfoID)
//        print("row clicked ", dataClick.id)
        
    }
    
    func showAlert(_ error : String){
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IngredientsViewController {
            destination.recipeID = recipeInfoID
        }
    }
    
}
