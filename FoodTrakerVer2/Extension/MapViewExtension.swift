//
//  MapViewExtension.swift
//  FoodTrakerVer2
//
//  Created by Tran Ngoc Nam on 7/7/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces

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
        
        listLikelyPlaces()
        
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

extension MapViewController: AutocompleteControllerDelegate {
    
    func passingData(place: GMSPlace?) {
        guard let dataPlace = place else { return }
        if checkIdentifier == true {
            source = LocationGG(name: dataPlace.name, formattedAddress: dataPlace.formattedAddress!, coordinate: dataPlace.coordinate)
            print("NamTN: \(String(describing: dataPlace.coordinate))🤥")
            startTextField.text = "\(dataPlace.name), \(dataPlace.formattedAddress ?? "")"
        } else {
            destination = LocationGG(name: dataPlace.name, formattedAddress: dataPlace.formattedAddress!, coordinate: dataPlace.coordinate)
            print("NamTN: \(String(describing: dataPlace.coordinate))")
            endTextField.text = "\(dataPlace.name), \(dataPlace.formattedAddress ?? "")"
        }
        displayPolyLine()
    }
    
    func displayPolyLine() {
        if source != nil && destination != nil {
            mapView.clear()
            
            guard let sourceLocation = source else { return }
            guard let destinationLocation = destination else { return }
            
            // create 2 marker
            _ = createMarker(location: sourceLocation)
            
            let marker = createMarker(location: destinationLocation)
            marker.icon = GMSMarker.markerImage(with: .blue)
            
            getPolylineRoute(from: sourceLocation.coordinate, to: destinationLocation.coordinate)
        }
    }
    
    func createMarker(location: LocationGG) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.title = location.name
        marker.snippet = location.formattedAddress
        marker.map = mapView
        return marker
    }
}

extension MapViewController {
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving"
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                guard let dataPlaces = data else { return }
                if let json = try JSONSerialization.jsonObject(with: dataPlaces, options: .mutableContainers) as? DICT {
                    guard let routes = json["routes"] as? [DICT] else { return }
                    if routes.count > 0 {
                        let overview_polyline: DICT = routes[0]
                        guard let dictPolyline = overview_polyline["overview_polyline"] as? DICT else { return }
                        guard let points = dictPolyline["points"] as? String else { return }
                        guard let path = GMSPath.init(fromEncodedPath: points) else { return }
                        
                        DispatchQueue.main.async {
                            self.loadDataOnMainThread(path: path)
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func loadDataOnMainThread(path: GMSPath) {
        let polyline = GMSPolyline.init(path: path)
        polyline.strokeColor = .init(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0)
        polyline.strokeWidth = 5.0
        polyline.map = self.mapView
        
        let bounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
        self.mapView.animate(with: cameraUpdate)
    }
}


