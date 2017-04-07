//
//  SavedTableViewController.swift
//  Sous Box
//
//  Created by Billy on 4/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FBSDKLoginKit
import FirebaseFacebookAuthUI

class SavedTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var recipeData: [FIRDataSnapshot]! = []
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
        
    }

    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        // listen for new messages in the firebase database
        _refHandle = ref.child("recipes").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
        self.recipeData.append(snapshot)
        self.tableView.insertRows(at: [IndexPath(row: self.recipeData.count, section: 0)], with: .automatic)
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeCell {
            
            
            return cell
        } else {
            return SavedRecipeCell()
        }
    }
 

    

}
