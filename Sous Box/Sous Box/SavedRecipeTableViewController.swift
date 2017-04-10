//
//  SavedRecipeTableViewController.swift
//  Sous Box
//
//  Created by Billy on 4/9/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import FirebaseFacebookAuthUI
import Kingfisher

class SavedRecipeTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var recipeList = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
    
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Something went wrong: ", error ?? "")
                return
            }
            print("user info: ", user?.uid ?? "")
            
            self.fetchRecipeData()

            
        })
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeCell {
            
            var recipeDat = Recipe()
            recipeDat = recipeList[indexPath.row]
            
            cell.savedRecipeTitle.text = recipeDat.title
            
            return cell
        } else {
            return SavedRecipeCell()
        }
    }
 

    func fetchRecipeData(){
        let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
//        let userRef = ref.child("recipes").child(userID)
        let userRef = ref.child(userID)
        
        self.refHandle = userRef.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                print (dictionary)
                
//                if let recipesData = dictionary["recipes"] as? [String, AnyObject] {
//                    let recipe = Recipe()
//                    
//                    recipe.setValuesForKeys(dictionary)
//                    self.recipeList.append(recipe)
//                    
//                    print(self.recipeList)
//                    
//                    self.tableView.reloadData()
//                }
            }
            
        })
    }
}
