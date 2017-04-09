//
//  SavedTableViewController.swift
//  Sous Box
//
//  Created by Billy on 4/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FBSDKLoginKit
import FirebaseFacebookAuthUI
import Kingfisher

class SavedTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var recipeData: [FIRDataSnapshot]! = []
    var storageRef: FIRStorageReference!
    var remoteConfig: FIRRemoteConfig!
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    var displayUserName: String!
    
    var recipe: FirebaseClient!
    var recipeArray = [FirebaseClient]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        configureAuth()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureAuth()
    }
    
    func configureAuth(){
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Something went wrong: ", error ?? "")
                return
            }
            
            print("Success: ", user?.uid ?? "")
            self.displayUserName = (user?.uid ?? "")
            print(self.displayUserName)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph: ", err ?? "")
            }
            print(result ?? "")
        }
        
        
        // listen for changes in the authorization state
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            // refresh table data
            self.recipeData.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            
            // check if there is a current user
            if let activeUser = user {
                // check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                    self.signedInStatus()
                    self.retrieveRecipe()
                }
            } else {
                // user must sign in
              
                
            }
        }
    }
    
    
    func signedInStatus() {
        configureDatabase()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
    }

    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        // listen for new messages in the firebase database
        _refHandle = ref.child("recipes").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
        self.recipeData.append(snapshot)
        self.tableView.insertRows(at: [IndexPath(row: self.recipeData.count, section: 0)], with: .automatic)
            
        }
    }
    
    func configureRemoteConfig() {
        // create remote config setting to enable developer mode
        let remoteConfigSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
        remoteConfig = FIRRemoteConfig.remoteConfig()
        remoteConfig.configSettings = remoteConfigSettings!
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference()
    }
    
    deinit {
        ref.child("recipes").removeObserver(withHandle: _refHandle)
        FIRAuth.auth()?.removeStateDidChangeListener(_authHandle)
    }
    
    func fetchConfig() {
        var expirationDuration: Double = 3600
        // if in developer mode, set cacheExpiration 0 so each fetch will retrieve values from the server
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        // cacheExpirationSeconds is set to cacheExpiration to make fetching faster in developer mode
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
            if status == .success {
//                print("Config fetched!")
                self.remoteConfig.activateFetched()
            }
        }
    }
    
    
    
    func showAlert(_ error : String){
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return recipeData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeCell {
            
            cell.savedRecipeTitle.text = recipe.title
            return cell
        } else {
            return SavedRecipeCell()
        }
    }
 
    func retrieveRecipe(){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://sous-box.firebaseio.com/")
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userRef = ref.child(userID!).child("recipes")
        
        userRef.observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                if let title = dict["title"] as? String {
                    let titleInfo = FirebaseClient(getInfo: title)
                }
                
            }
        })
    }
}
