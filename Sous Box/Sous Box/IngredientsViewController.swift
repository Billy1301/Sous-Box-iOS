//
//  IngredientsViewController.swift
//  Sous Box
//
//  Created by Billy on 3/31/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var instructionsText: UITextView!
    @IBOutlet weak var ingredientsButton: UIButton!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var ingredientSpoon: Spoonacular!
    var ingredientSpoonArray = [Spoonacular]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstUIBtn()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setFirstUIBtn(){
        setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsButton, color: .white)
        setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsButton, color: .gray)
        setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareButton, color: .gray)
    }
    
    func setUIBtn(image: UIImage, button: UIButton, color: UIColor){
        
        let origImage = image
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
        button.setTitleColor(color, for: .normal)
        
    }
    
    
    @IBAction func ingredBtnPressed(_ sender: Any) {
        setUIBtn(image: #imageLiteral(resourceName: "lists"), button: ingredientsButton, color: .white)
        setUIBtn(image: #imageLiteral(resourceName: "cooking"), button: instructionsButton, color: .gray)
        setUIBtn(image: #imageLiteral(resourceName: "share"), button: shareButton, color: .gray)
    }
    
    @IBAction func instructionBtnPressed(_ sender: Any) {
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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath)
        
//        cell.textLabel?.text = ingredientSpoon._originalString
        
        return cell
    }
}
