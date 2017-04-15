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
    var refHandle: UInt!
    var recipeList = [Recipe]()
    var recipeInfo: [String] = []
    private var databaseHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
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
    
    func logoutFirebase(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
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
        recipeInfo = ["\(dataClick.id)", dataClick.image, "savedSegue"]
        self.performSegue(withIdentifier: "IngredientsSegue", sender: recipeInfo)
    }
    
    // deleting row and firebase data
    // http://stackoverflow.com/questions/3309484/uitableviewcell-show-delete-button-on-swipe/37719543#37719543
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let userID: String = (FIRAuth.auth()?.currentUser?.uid) else {
                return
            }
            
            let recipeKey = recipeList[indexPath.row]
            let userRef = ref.child(userID).child("recipes")
            let uk = recipeKey.key
            userRef.child(uk).removeValue()
            
        }
//         remove the item from the data model
        recipeList.remove(at: indexPath.row)
        
//         delete the table view row
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IngredientsViewController {
            destination.recipeID = recipeInfo[0]
            destination.recipePhotoUrl = recipeInfo[1]
            destination.recipeSegueID = recipeInfo[2]
        }
    }
    
    // MARK: - Fetch Firebase Data
 
    //getting data from firebase
    func fetchRecipeData(){
        
        // remove list first for search function to work properly
        self.recipeList.removeAll()
        
        guard let userID: String = (FIRAuth.auth()?.currentUser?.uid) else {
            return
        }

        let userRef = ref.child(userID).child("recipes")
        self.refHandle = userRef.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let recipeInfo = Recipe(dictionary: dictionary)
                self.recipeList.append(recipeInfo)
                
                //use dispatchqueue to reloaddata or it will crash
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
    }

}
