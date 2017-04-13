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

class SavedRecipeTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var ref: FIRDatabaseReference!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var refHandle: UInt!
    var recipeList = [Recipe]()
    var recipeInfo: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(SavedRecipeTableViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.tableView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if currentReachabilityStatus != .notReachable {
            if FIRAuth.auth()?.currentUser?.uid == nil {
                self.showAlert("Must sign in to Facebook to use")
                logoutFirebase()
                self.recipeList.removeAll()
                self.tableView.reloadData()
            } else {
                self.fetchRecipeData()
            }
        } else {
            showAlert("No network connection")
        }
        
    }
    
    func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let p = gestureReconizer.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        
        if let index = indexPath {
            var row = self.tableView.cellForRow(at: index)
            // do stuff with your cell, for example print the indexPath
        
            print("Removed: ", index.row)
        } else {
            
        }
    }
    
    
    func logoutFirebase(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    // to get user info
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IngredientsViewController {
            destination.recipeID = recipeInfo[0]
            destination.recipePhotoUrl = recipeInfo[1]
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeCell {
            
            let recipeDat = recipeList[indexPath.row]
            let photoURL = URL(string: "\(URL_IMAGE_BASE)"+recipeDat.image)
            
            cell.savedRecipeTitle.text = recipeDat.title
            cell.savedRecipeImage.kf.indicatorType = .activity
            cell.savedRecipeImage.kf.setImage(with: photoURL)
            cell.savedReadyInMinutes.text = "Ready in minutes: \(recipeDat.readyInMinutes)"
            
            return cell
        } else {
            return SavedRecipeCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataClick = recipeList[indexPath.row]
        recipeInfo = ["\(dataClick.id)", dataClick.image]
        self.performSegue(withIdentifier: "IngredientsSegue", sender: recipeInfo)
        
        
    }
    
 
    func fetchRecipeData(){
        self.recipeList.removeAll()
        
        let userID: String = (FIRAuth.auth()?.currentUser?.uid)!
        let userRef = ref.child(userID).child("recipes")
        
        self.refHandle = userRef.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let recipeInfo = Recipe(dictionary: dictionary)    
                self.recipeList.append(recipeInfo)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
    }

}
