//
//  MapViewController.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/7/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50.0
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        return locationManager
    }()

    @IBOutlet weak var mapView: GMSMapView!
    
    // Slide menu constraint
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    var isSlideMenuHidden = true
    
    // MARK: Outlet
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    var checkIdentifier: Bool = true
    var source: LocationGG?
    var destination: LocationGG?
    
    var marker: GMSMarker!
    var markerSecond: GMSMarker!
    
    var currentLocaton: CLLocation!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        
        sideMenuConstraint.constant = -200
        
        listLikelyPlaces()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedPlace != nil {
            print(selectedPlace!.name)
        }
        listLikelyPlaces()
    }
    
    func listLikelyPlaces() {
        likelyPlaces.removeAll()
        
        placesClient.currentPlace { (placeLikelihoods, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            // xử lý khi có dữ liệu
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailController = segue.destination as? AutocompleteController
        detailController?.delegate = self
        if segue.identifier == "end" {
            checkIdentifier = false
        }
    }
    
    // MARK: Search places
    @IBAction func searchPlaces(_ sender: UIBarButtonItem) {
        source = nil
        destination = nil
        startTextField.displayText(text: "Bạn đang ở đâu?")
        endTextField.displayText(text: "Bạn muốn đi đâu?")
        checkIdentifier = true
        if isSlideMenuHidden {
            sideMenuConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            sideMenuConstraint.constant = -200
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        isSlideMenuHidden = !isSlideMenuHidden
    }
    
    @IBAction func setMyLocation(_ sender: UIButton) {
        print("NamTN: \(String(describing: mapView.myLocation?.coordinate))")
        startTextField.displayText(text: "Vị trí của tôi")
        source = LocationGG(name: "Vị trí của tôi", formattedAddress: "", coordinate: (mapView.myLocation?.coordinate)!)
        displayPolyLine()
    }
    
    @IBAction func swapLocation(_ sender: UIButton) {
        let temp: LocationGG?
        temp = source
        source = destination
        destination = temp
        //
        if source != nil {
            startTextField.displayLocation(location: source!)
        } else {
            startTextField.displayText(text: "Bạn đang ở đâu?")
        }
        //
        if destination != nil {
            endTextField.displayLocation(location: destination!)
        } else {
            endTextField.displayText(text: "Bạn muốn đi đâu?")
        }
        //
        displayPolyLine()
    }

}
