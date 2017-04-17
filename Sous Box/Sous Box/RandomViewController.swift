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
    
    var ref: FIRDatabaseReference!
    var randomSpoon: Spoonacular!
    var randomSpoonArray = [Spoonacular]()
    var recipeInfoID: String = ""
    var recipeInfo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        if currentReachabilityStatus != .notReachable {
            // create tap gesture for photo
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RandomViewController.imageTapped(gesture:)))
            recipeImage.addGestureRecognizer(tapGesture)
            recipeImage.isUserInteractionEnabled = true
            
            self.downloadRecipeData {

            }
        } else {
            showAlert("No network connection")
        }
    }
    
    @IBAction func likeBtnPressed(_ sender: Any) {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            showAlert("Need to sign in to Facebook to save")
        } else {
            sendToFirebaseDatabase()
            downloadRecipeData {
                
            }
        }
    }
    
    @IBAction func dislikeBtnPressed(_ sender: Any) {
        downloadRecipeData {
            
        }
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        
        if (gesture.view as? UIImageView) != nil {
            performSegue(withIdentifier: "IngredientsSegue", sender: recipeInfo)
            
        }
    }
    
    // MARK: - Fetch Firebase Data
    
    func downloadRecipeData(completed: @escaping DownloadComplete) {
        randomSpoonArray.removeAll()
        
        let currentRecipeURL = URL(string: GET_RANDOM_URL)!
        
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result

            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let results = dict["recipes"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in results {
                        let recipes = Spoonacular(getRecipeLists: obj)
                        self.randomSpoonArray.append(recipes)
                        
                        if recipes.image == "" {
                            self.recipeImage.image = #imageLiteral(resourceName: "noImage")
                        }
                        
                        let photoURL = URL(string: recipes.image)
                        self.recipeImage.kf.indicatorType = .activity
                        self.recipeImage.kf.setImage(with: photoURL)
                        self.recipeInfoID = "\(recipes.id)"
                        self.recipeTitle.text = recipes.title
                        self.recipeInfo = ["\(recipes.id)", recipes.image, "randomSegue"]
                    }
                }
            }
            completed()
        }
    }
    
    func sendToFirebaseDatabase(){
        
        guard let userID: String = (FIRAuth.auth()?.currentUser?.uid) else {
            return
        }

        if FIRAuth.auth()?.currentUser?.uid == nil {
            showAlert("Need to sign in to facebook to save")
        } else {
            let userRef = ref.child(userID).child("recipes").childByAutoId()
            let data = randomSpoonArray[0]
            
            // remove the first half of the link to save to firebase to work for favorite tab
            let revisedImage = randomSpoonArray[0].image.replacingOccurrences(of: "https://spoonacular.com/recipeImages/", with: "")
            let recipePhotoUrlToUse = revisedImage
            
            let childAutoID = userRef.key
            
            //must create dict to push data to firebase
            let dict = ["id": data.id, "title": data.title, "image": recipePhotoUrlToUse, "readyInMinutes": "\(data.readyInMinutes)", "key": childAutoID] as [String : Any]
            
            userRef.setValue(dict)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IngredientsViewController {
            
            //setting the getter/setter for ingredients VC to populate correctly
            destination.recipeID = recipeInfo[0]
            destination.recipePhotoUrl = recipeInfo[1]
            destination.recipeSegueID = recipeInfo[2]
        }
    }
}


// create extension for alert to use throughtout the project
extension UIViewController {
    func showAlert(_ error : String){
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
