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

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var ingredientsButton: UIButton!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    var ingredientSpoon: Spoonacular!
    var ingredientSpoonArray = [Spoonacular]()
    
    var recipeURLShare: String = ""
    var recipeTitle: String = ""
    var instructionsArray = [Spoonacular]()
    
    //Getter/Setter to get data from segue
    var _recipeID: String!
    
    var recipeID: String {
        get {
            return _recipeID
        } set {
            _recipeID = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstUI()
        downloadRecipeDetails(recipeID: recipeID){
            self.ingredientsTableView.reloadData()
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func downloadRecipeDetails(recipeID: String, completed: @escaping DownloadComplete) {
        
        let currentRecipeURL = URL(string: URL_BASE + recipeID + URL_GET_RECIPE)!
        
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
            print(response)
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
                    
                    if self.instructionsTextView.text.isEmpty || instruction == nil {
                        self.instructionsTextView.text = self.recipeURLShare
                        print(self.recipeURLShare)
                    }
                    
//                    print(self.recipeURLShare)
//                    print (instruction)
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
        setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsButton, color: .white)
        setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsButton, color: .gray)
        setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareButton, color: .gray)
        instructionsTextView.isHidden = true
    }
    
    func setUIBtn(image: UIImage, button: UIButton, color: UIColor){
        
        let origImage = image
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
        button.setTitleColor(color, for: .normal)
        
    }
    
    
    @IBAction func ingredBtnPressed(_ sender: Any) {
        ingredientsTableView.isHidden = false
        instructionsTextView.isHidden = true
        setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsButton, color: .white)
        setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsButton, color: .gray)
        setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareButton, color: .gray)
    }
    
    @IBAction func instructionBtnPressed(_ sender: Any) {
        instructionsTextView.isHidden = false
        ingredientsTableView.isHidden = true
        setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsButton, color: .gray)
        setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsButton, color: .white)
        setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareButton, color: .gray)
        
        
    }

    @IBAction func shareBtnPressed(_ sender: Any) {
        setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsButton, color: .gray)
        setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsButton, color: .gray)
        setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareButton, color: .white)
    
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
