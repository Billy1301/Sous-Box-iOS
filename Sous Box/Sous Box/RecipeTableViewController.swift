//
//  RecipeTableViewController.swift
//  Sous Box
//
//  Created by Billy on 3/29/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Alamofire


class RecipeTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var spoon: Spoonacular!
    var spoons = [Spoonacular]()
    var searchSpoons = [Spoonacular]()
    
    var inSearchMode = false
    
    var search_query: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        searchBar.returnKeyType = UIReturnKeyType.done
        
        if currentReachabilityStatus != .notReachable {
            if inSearchMode == false {
                downloadRecipeData(search: search_query) {
                    self.tableView.reloadData()
                }
            }
        } else {
            self.showAlert("No Network Found")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func downloadRecipeData(search: String, completed: @escaping DownloadComplete) {
    
        let search_keywords = search.replacingOccurrences(of: " ", with: "+")
//        print(search_keywords)
        
        let currentRecipeURL = URL(string: CURRENT_SEARCH_URL + search_keywords)!
        
        Alamofire.request(currentRecipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let results = dict["results"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in results{
                        let recipes = Spoonacular(getRecipeLists: obj)
                       
                        if self.inSearchMode == true {
                            self.searchSpoons.append(recipes)
                        } else {
                            self.spoons.append(recipes)
                        }
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
    
    // search function
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        inSearchMode = true
        search_query = searchBar.text!
        searchSpoons.removeAll()
        downloadRecipeData(search: search_query) {
            self.tableView.reloadData()
        }
        view.endEditing(true)

    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode == true {
            return searchSpoons.count
        } else {
            return spoons.count
        }
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCellView {
            if inSearchMode == true {
                let searchData = searchSpoons[indexPath.row]
                cell.configureCell(spoon: searchData)
            } else {
                let data = spoons[indexPath.row]
                cell.configureCell(spoon: data)
            }
           
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
