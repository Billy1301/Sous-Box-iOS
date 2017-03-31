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
    
    var search_query = "korean beef"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentReachabilityStatus != .notReachable {
            downloadRecipeData {
                self.tableView.reloadData()
            }
        } else {
            self.showAlert("No Network Found")
        }
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
    
    }
    
    func downloadRecipeData(completed: @escaping DownloadComplete) {
        
        let search_keywords = search_query.replacingOccurrences(of: " ", with: "+")
        
        let currentRecipeURL = URL(string: CURRENT_SEARCH_URL + search_keywords)!
        
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let results = dict["results"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in results{
                        let recipes = Spoonacular(getRecipeLists: obj)
                        self.spoons.append(recipes)
                    }
                }
            }
            completed()
        }
    }
    
    func showAlert(_ error : String){
        let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCellView {

            let data = spoons[indexPath.row]
            cell.configureCell(spoon: data)
            
            return cell
        } else {
            return RecipeCellView()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataClick = spoons[indexPath.row]
        print("row clicked ", dataClick._id)
    }

}
