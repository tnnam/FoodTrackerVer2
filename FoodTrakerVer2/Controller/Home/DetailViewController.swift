//
//  DetailTableViewController.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/6/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMaps
import GooglePlaces

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var kind: String?
    var meal: Meal?
    var locationItem: Location?
    
    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var rating: RatingControl!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var shortDesc: UITextView!
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealName.delegate = self
        configureDetail()
        updateSaveButtonStates()
    }
    
    func configureDetail() {
        guard let meal = meal else { return }
        navigationItem.title = meal.name
        mealName.text = meal.name
        photo.download(from: meal.photo)
        rating.rating = meal.rating
        price.text = "\(meal.price) VND"
        address.text = "\(meal.location.formattedAddress)"
        print("NamTN: \(meal.location.name)")
        startTime.text = meal.time.start
        endTime.text = meal.time.end
        shortDesc.text = "Short Desc: \(meal.shortDesc)"
        review.text = meal.review
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            let autocompleteController = (segue.destination as? UINavigationController)?.topViewController as? AutocompleteController
            autocompleteController?.delegate = self
            if let mealTableViewController = segue.destination as? MealTableViewController {
                if mealTableViewController.tableView.indexPathForSelectedRow == nil && meal == nil {
                    meal = createMeal()
                    meal!.ref = Database.database().reference(withPath: kind?.lowercased() ?? "")
                    let mealItemRef = meal!.ref?.child(meal!.name.lowercased())
                    mealItemRef?.setValue(meal?.toAnyObject())
                }
            }
        } else {
            let mapViewController = segue.destination as? MapViewController
            mapViewController?.meal = meal
        }
    }
    
    func createMeal() -> Meal {
        var mealItem: Meal?
        let mealName = self.mealName.text ?? ""
        let photo = "https://www.google.com.vn/search?q=image&source=lnms&tbm=isch&sa=X&ved=0ahUKEwiJncSn_4bcAhUU3o8KHU8xChIQ_AUICigB&biw=1440&bih=826#imgrc=b44zXHD524b2rM:"
        let rating: Int = self.rating.rating
        let price: Int = Int(self.price.text ?? "") ?? 0
        let location: Location = locationItem!
        let startTime = self.startTime.text ?? "0:00"
        let endTime = self.endTime.text ?? "0:00"
        let shortDesc = self.shortDesc.text ?? ""
        let review = self.review.text ?? ""
        // create model
        let time = Time(start: startTime, end: endTime)
        mealItem = Meal(id: "ABC", name: mealName, photo: photo, rating: rating, price: price, location: location, time: time, shortDesc: shortDesc, review: review)
        return mealItem!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        photo.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonStates()
        navigationItem.title = textField.text
    }

    // MARK: private method
    private func updateSaveButtonStates() {
        let text = mealName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

extension DetailViewController: AutocompleteControllerDelegate {
    func passingData(place: GMSPlace?) {
        guard let dataPlace = place else { return }
        let name = dataPlace.name
        let formattedAddress = dataPlace.formattedAddress ?? ""
        let latitude = String(dataPlace.coordinate.latitude)
        let longitude = String(dataPlace.coordinate.longitude)
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)
        locationItem = Location(name: name, formattedAddress: formattedAddress, coordinate: coordinate)
        print("\(dataPlace.coordinate.latitude) \(dataPlace.coordinate.longitude)")
        address.text = "\(String(describing: dataPlace.formattedAddress!))"
    }
}
