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

    var filterMeals : [Meal] = []

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = kind
        configure()
        DataService.shared.getData(key: kind!) { (meals) in
            print(meals.count)
        }
        uploadDataToFirebase()
        
        // setup searchController
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Meal"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func configure() {
        guard let kind = kind else { return }
        ref = Database.database().reference(withPath: kind.lowercased())
        loadData()
    }
    
    func uploadDataToFirebase() {
        DataService.shared.getData(key: kind!) { (mealsPlist) in
            print("NamTN: \(mealsPlist[0].location.name)")
            for meal in mealsPlist {
                let mealItemRef = self.ref.child(meal.id.lowercased())
                mealItemRef.setValue(meal.toAnyObject())
            }
        }
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
        if searchController.isActive {
            return filterMeals.count
        }
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MealTableViewCell
        let meal: Meal = !searchController.isActive ? meals[indexPath.row] : filterMeals[indexPath.row]
        configureCell(meal: meal, cell: cell)
        return cell
    }

    func configureCell(meal: Meal, cell: MealTableViewCell) {
        cell.nameLabel.text = meal.name
        cell.photoImageView.download(from: meal.photo)
        print("\(meal.id) \(meal.name) \(meal.photo) \(meal.rating)")
        cell.ratingControl.rating = meal.rating
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let mealItem = meals[indexPath.row]
            mealItem.ref?.removeValue()
            self.loadData()
        }
    }

    // MARK: - Navigation
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
    
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        if segue.identifier == "edit" {
            guard let index = tableView.indexPathForSelectedRow else { return }
            detailViewController.meal = meals[index.row]
        }
        detailViewController.kind = kind
    }
}

extension MealTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            let fetchedObjects = meals
            filterMeals = fetchedObjects.filter({ (meal) -> Bool in
                return meal.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            tableView.reloadData()
        }
    }
}
