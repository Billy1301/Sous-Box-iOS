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
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var refHandle: UInt!
    var recipeList = [Recipe]()
    var user: FIRUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        getUserInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            self.showAlert("Must sign in to Facebook to use")
            logoutFirebase()
            self.recipeList.removeAll()
            self.tableView.reloadData()
        } else {
            self.fetchRecipeData()
        }
    }
    
    func logoutFirebase(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    
    func getUserInfo(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Something went wrong: ", error ?? "")
                return
            }
            print("user info: ", user?.uid ?? "")
            
        })
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeCell {
            
            let recipeDat = recipeList[indexPath.row]
            
            cell.savedRecipeTitle.text = recipeDat.title
            
            return cell
        } else {
            return SavedRecipeCell()
        }
    }
 

    func fetchRecipeData(){
        self.recipeList.removeAll()
//        self.tableView.reloadData()
        
        let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
//        let userRef = ref.child("recipes").child(userID)
        let userRef = ref.child(userID).child("recipes")
        
        self.refHandle = userRef.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
//                print (dictionary)
                
                let recipeInfo = Recipe(dictionary: dictionary)
//                recipeInfo.id = snapshot.key
    
                self.recipeList.append(recipeInfo)
                    
//                print(self.recipeList)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    
    
    func showAlert(_ error : String){
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
