//
//  AddPinsViewController.swift
//  On The Map
//
//  Created by Patrick on 10/28/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class AddPinsViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        urlTextField.delegate = self
    }

    @IBAction func update(_ sender: Any) {
        guard !(urlTextField.text?.isEmpty)! else {
            label.text = "URL is empty"
            return
        }
        geocoder.geocodeAddressString(addressTextField.text!) {
            placemarks, error in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    self.label.text = " Can't find this location. Try again"
                    return
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            var annotations : [MKPointAnnotation] = []
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print("$$$$  \(lat) \(lon)",error,placemarks,location)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
//            annotation.title = "\(first) \(last)"
//            annotation.subtitle = mediaURL
            annotations.append(annotation)
            self.mapView.addAnnotations(annotations)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            
            let key = MapClient.sharedInstance().key
            let firstName = MapClient.sharedInstance().firstName
            let lastName = MapClient.sharedInstance().lastName
            let url = self.urlTextField.text
//            MapClient.sharedInstance().createInfo(key:key!, firstName: firstName!, lastName: lastName!,url: url!,lat:39.7285,lon:-121.8375)
            MapClient.sharedInstance().createInfo(key:key!, firstName: firstName!, lastName: lastName!,url: url!,lat:lat,lon:lon)

        }
        
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
    }


}
