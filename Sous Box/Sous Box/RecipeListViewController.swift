//
//  RecipeListViewController.swift
//  Sous Box
//
//  Created by Billy on 3/20/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

    var spoon: Spoonacular!
    var spoons = [Spoonacular]()
    var spoonacular = Spoonacular()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        spoonacular.downloadRecipeData {
            //setup UI to load data
        }
    }

  
    // setup tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spoons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCellView {
            
            let spoon = spoons[indexPath.row]
            cell.configureCell(spoon: spoon)
            return cell
        } else {
            return RecipeCellView()
        }
    }
    


}
