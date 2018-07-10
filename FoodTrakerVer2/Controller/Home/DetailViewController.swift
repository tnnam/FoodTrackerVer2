//
//  DetailTableViewController.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/6/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var meal: Meal?
    
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
        navigationItem.title = meal?.name
        configureDetail()
        updateSaveButtonStates()
    }
    
    func configureDetail() {
        guard let meal = meal else { return }
        mealName.text = meal.name
        photo.image = #imageLiteral(resourceName: "sashimi")
        rating.rating = meal.rating
        price.text = "\(meal.price) VND"
        address.text = "\(meal.location.name) ,\(meal.location.formattedAddress)"
        startTime.text = meal.time.start
        endTime.text = meal.time.end
        shortDesc.text = "Short Desc: \(meal.shortDesc)"
        review.text = meal.review
        
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
