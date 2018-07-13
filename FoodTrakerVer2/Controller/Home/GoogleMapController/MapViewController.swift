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
    var meal: Meal?
    // Slide menu constraint
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    var isSlideMenuHidden = true
    // MARK: Outlet
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    var source: LocationGG?
    var destination: LocationGG?
    
    var marker: GMSMarker!
    var markerSecond: GMSMarker!
    
    var currentLocaton: CLLocation!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLocation()
    }
    
    // MARK: Search places
    @IBAction func searchPlaces(_ sender: UIBarButtonItem) {
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
    
    func setLocation() {
        print("NamTN: \(String(describing: mapView.myLocation?.coordinate))")
        startTextField.displayText(text: "Vị trí của tôi")
        source = LocationGG(name: "Vị trí của tôi", formattedAddress: "", coordinate: (mapView.myLocation?.coordinate)!)
        let coordinate =  CLLocationCoordinate2D(latitude: Double(meal?.location.coordinate.latitude ?? "") ?? 0, longitude: Double(meal?.location.coordinate.longitude ?? "") ?? 0)
        destination = LocationGG(name: meal?.location.name ?? "", formattedAddress: meal?.location.formattedAddress ?? "", coordinate: coordinate)
        startTextField.displayLocation(location: source!)
        endTextField.displayLocation(location: destination!)
        displayPolyLine()
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location :\(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        marker = nil
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

