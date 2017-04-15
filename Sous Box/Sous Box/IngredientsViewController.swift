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
    var readyInMinutes: String = ""
    var recipeKey: String = ""
    var instructionsArray = [Spoonacular]()
    
    // Getter/Setter to get data from segue
    var _recipeID: String!
    var _recipePhotoUrl: String!
    var _recipeSegueID: String!
    
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
    
    var recipeSegueID: String {
        get {
            return _recipeSegueID
        } set {
            _recipeSegueID = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        setFirstUI()
        self.setSaveUnSaveBtn(segueKey: recipeSegueID)
        
        if currentReachabilityStatus != .notReachable {
            self.downloadRecipeDetails(recipeID: recipeID){
                self.ingredientsTableView.reloadData()
            }
        } else {
            showAlert("No network connection")
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRecipeBtn(_ sender: Any) {
        
        guard let userID: String = (FIRAuth.auth()?.currentUser?.uid) else {
            return
        }
       
        let userRef = ref.child(userID).child("recipes").childByAutoId()
        let key = userRef.key
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            showAlert("Must sign in to Facebook to use")
            
            } else {
            
            if saveBtnLbl.currentTitle == "Save" {
                saveBtnLbl.setTitle("Un-Save", for: .normal)
                
                //must create dictionary to push data to firebase
                //http://stackoverflow.com/questions/38231055/save-array-of-classes-into-firebase-database-using-swift
                let dict = ["id": Int(recipeID) ?? "", "title": titleLbl.text ?? "", "image": recipePhotoUrl, "readyInMinutes": readyInMinutes, "key": key] as [String : Any]
                
                userRef.setValue(dict)
                print("Saved recipe key: ",key)
                recipeKey = key
                print(recipeKey)
            } else {
                saveBtnLbl.setTitle("Save", for: .normal)
                let deleteRef = ref.child(userID).child("recipes")
                deleteRef.child(recipeKey).removeValue()
                print("unsaved: ", recipeKey)
                
            }
        }
    }

    func setSaveUnSaveBtn(segueKey: String) {
        if segueKey == "recipeListSegue" {
            saveBtnLbl.isEnabled = true
            saveBtnLbl.isHidden = false
        } else {
            saveBtnLbl.isEnabled = false
            saveBtnLbl.isHidden = true
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
                
                if let readyInMin = dict["readyInMinutes"] as? Int {
                    self.readyInMinutes = "\(readyInMin)"
                }
                
//                if let recipeKeyID = dict["key"] as? String {
//                    self.recipeKey = recipeKeyID
//                }
                
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
        saveBtnLbl.isEnabled = false
        saveBtnLbl.isHidden = true
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
