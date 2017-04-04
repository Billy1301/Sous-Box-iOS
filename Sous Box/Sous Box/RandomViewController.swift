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
    
    var spoon: Spoonacular!
    var spoons = [Spoonacular]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func likeBtnPressed(_ sender: Any) {
    
    }
    
    @IBAction func dislikeBtnPressed(_ sender: Any) {
    
    }
    
    func downloadRecipeData(search: String, completed: @escaping DownloadComplete) {
        
        let search_keywords = search.replacingOccurrences(of: " ", with: "+")
        //        print(search_keywords)
        
        let currentRecipeURL = URL(string: CURRENT_SEARCH_URL + search_keywords)!
        
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let results = dict["results"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in results{
                        let recipes = Spoonacular(getRecipeLists: obj)
                        self.spoons.append(recipes)
                    }
                }
            }
            completed()
        }
    }
    
    func showAlert(_ error : String){
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    
}
