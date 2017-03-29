//
//  RecipeListViewController.swift
//  Sous Box
//
//  Created by Billy on 3/20/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var spoon: Spoonacular!
    var spoons = [Spoonacular]()
    var spoonData: [Spoonacular] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadRecipesData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    // get data from API
    func downloadRecipesData() {
        //Download recipes
        let recipeURL = URL(string: CURRENT_SEARCH_URL)!
        
        Alamofire.request(recipeURL, method: .get, headers: HEADERS).responseJSON { response in
            
            let result = response.result
            print(response)
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["results"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let recipes = Spoonacular(getRecipeLists: obj)
                        self.spoons.append(recipes)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    // setup tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spoons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let photoURL = URL(string: "\(URL_IMAGE_BASE)\(spoon.image)")
        cell.imageView?.kf.setImage(with: photoURL)
        cell.textLabel?.text = spoon.title
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }

}
