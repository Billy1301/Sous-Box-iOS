//
//  RecipeTableViewController.swift
//  Sous Box
//
//  Created by Billy on 3/29/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Alamofire


class RecipeTableViewController: UITableViewController {

    var spoon: Spoonacular!
    var spoons = [Spoonacular]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadRecipeData()
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func downloadRecipeData() {
        
        let currentRecipeURL = URL(string: CURRENT_SEARCH_URL)!
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
            print(response)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let results = dict["results"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in results {
                        let recipes = Spoonacular(getRecipeLists: obj)
                        self.spoons.append(recipes)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return spoons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell")
        
//        let photoURL = URL(string: URL_IMAGE_BASE + spoon.image)
//        cell?.imageView?.kf.setImage(with: photoURL)
//        cell?.textLabel?.text = spoon.title
        
        return cell!
        
    }

}
