//
//  IngredientsViewController.swift
//  Sous Box
//
//  Created by Billy on 3/31/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Firebase
import FirebaseAuthUI

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var ingredientsBtn: UIButton!
    @IBOutlet weak var instructionsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var saveBtnLbl: UIButton!
    
    var ingredientSpoon: Spoonacular!
    var ingredientSpoonArray = [Spoonacular]()
    
    var ref: FIRDatabaseReference!
    var recipeURLShare: String = ""
    var recipeTitle: String = ""
    var instructionsArray = [Spoonacular]()
    
    // Getter/Setter to get data from segue
    var _recipeID: String!
    var _recipePhotoUrl: String!
    
    var recipeID: String {
        get {
            return _recipeID
        } set {
            _recipeID = newValue
        }
    }
    
    var recipePhotoUrl: String {
        get {
            return _recipePhotoUrl
        } set {
            _recipePhotoUrl = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        setFirstUI()
        
        
        if currentReachabilityStatus != .notReachable {
            if FIRAuth.auth()?.currentUser?.uid == nil {
                showAlert("Need to sign in to facebook to save")
            } else {
                self.downloadRecipeDetails(recipeID: recipeID){
                    self.ingredientsTableView.reloadData()
                }
            }
            
        } else {
            showAlert("No network connection")
        }
       
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRecipeBtn(_ sender: Any) {
        if saveBtnLbl.currentTitle == "Save" {
            saveBtnLbl.setTitle("Un-Save", for: .normal)
            
            let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
            let userRef = ref.child(userID)
            
            //must create dict to push data to firebase
//            let dict = ["id": data.id, "title": data.title, "image": recipePhotoUrlToUse, "readyInMinutes": "\(data.readyInMinutes)"] as [String : Any]
//            
//            userRef.child("recipes").childByAutoId().setValue(dict)
            
            print("save recipe")
        } else {
            saveBtnLbl.setTitle("Save", for: .normal)
            print("unsave")
            
        }
        
    }
    
    
    
    // download recipe data and plug into UI
    func downloadRecipeDetails(recipeID: String, completed: @escaping DownloadComplete) {
        
        let currentRecipeURL = URL(string: URL_BASE + recipeID + URL_GET_RECIPE)!
        
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
//            print(response)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let recipeURL = dict["spoonacularSourceUrl"] as? String {
                    self.recipeURLShare = recipeURL
                }
                
                if let title = dict["title"] as? String {
                    self.titleLbl.text = title
                }
                
                if let image = dict["image"] as? String {

                    let imageURL = URL(string: image)
                    self.recipeImage.kf.indicatorType = .activity
                    self.recipeImage.kf.setImage(with: imageURL)
                }
                
                if let instruction = dict["instructions"] as? String {
                    let filterInstrction = instruction.replacingOccurrences(of: ". ", with: ".\n\n")
                    self.instructionsTextView.text = filterInstrction
                    
                    if filterInstrction == "" || filterInstrction == " " {
                        self.instructionsTextView.text = self.recipeURLShare
//                        print(self.recipeURLShare)
                    }
                }
                
                if let ingredients = dict["extendedIngredients"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in ingredients{
                        let recipes = Spoonacular(getIngredients: obj)
                        self.ingredientSpoonArray.append(recipes)
                    }
                }
            }
            completed()
        }
    }
    
    func setFirstUI(){
        
        setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsBtn, color: .white)
        setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsBtn, color: .gray)
        setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareBtn, color: .gray)
        instructionsTextView.isHidden = true
    }
    
    func setUIBtn(image: UIImage, button: UIButton, color: UIColor){
        
        let origImage = image
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
        button.setTitleColor(color, for: .normal)
        
    }
    
    
    @IBAction func buttonsPressed(_ sender: Any) {
        
        let senderButton = sender as! UIButton
        let isIngredientsView = true
        
        if senderButton === ingredientsBtn {
            ingredientsTableView.isHidden = !isIngredientsView
            instructionsTextView.isHidden = isIngredientsView
            setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsBtn, color: .white)
            setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsBtn, color: .gray)
            setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareBtn, color: .gray)
        } else if senderButton === instructionsBtn {
            ingredientsTableView.isHidden = isIngredientsView
            instructionsTextView.isHidden = !isIngredientsView
            setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsBtn, color: .gray)
            setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsBtn, color: .white)
            setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareBtn, color: .gray)
        } else if senderButton === shareBtn {
            setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsBtn, color: .gray)
            setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsBtn, color: .gray)
            setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareBtn, color: .white)
            
            
            // pull up action to share 
            let urlToShare = URL(string: recipeURLShare)
            let activityViewController = UIActivityViewController(activityItems: [urlToShare ?? ""], applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { activity, completed, items, error in
                if completed {
                    print(urlToShare ?? "")
                    
                }
            }
            present(activityViewController, animated: true, completion: {})

        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientSpoonArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
        let data = ingredientSpoonArray[indexPath.row]
        cell.textLabel?.text = data.originalString
        return cell
    }
}
