//
//  MealTableViewController.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/6/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MealTableViewController: UITableViewController {

    var kind: String?
    
    var meals: [Meal] = []
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = kind
        configure()
    }
    
    func configure() {
        guard let kind = kind else { return }
        ref = Database.database().reference(withPath: kind.lowercased())
        loadData()
    }

    func loadData() {
        ref.queryOrdered(byChild: "id").observe(.value) { (snapshot) in
            var newItem: [Meal] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    if let mealItem = Meal(snapshot: snapshot) {
                        newItem.append(mealItem)
                    }
                }
            }
            self.meals = newItem
            self.tableView.reloadData()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MealTableViewCell
        let meal: Meal = meals[indexPath.row]
        configureCell(meal: meal, cell: cell)
        return cell
    }

    func configureCell(meal: Meal, cell: MealTableViewCell) {
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = #imageLiteral(resourceName: "sashimi")
        cell.ratingControl.rating = meal.rating
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        guard let index = tableView.indexPathForSelectedRow else { return }
        detailViewController.meal = meals[index.row]
    }
}
