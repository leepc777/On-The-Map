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


class AddPinsViewController: UIViewController,UITextFieldDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var newInfo = Personal() // new info for updating to cloud
    var geocoder = CLGeocoder()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        urlTextField.delegate = self
        
        addressTextField.keyboardType = UIKeyboardType.alphabet
        addressTextField.autocorrectionType = UITextAutocorrectionType.yes
        
        urlTextField.keyboardType = UIKeyboardType.URL
        urlTextField.autocorrectionType = UITextAutocorrectionType.yes

        
    }

    // Action for searching
    @IBAction func search(_ sender: Any) {
        guard !(urlTextField.text?.isEmpty)! else {
//            label.text = "URL is empty"
            showAlert(title: "URL", message: "URL is empty")
            return
        }
        
        //set up indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        geocoder.geocodeAddressString(addressTextField.text!) {
            placemarks, error in
            
            // stop indicator after getting Placemarks/error in closure
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    self.label.text = "\(error!)"
                    self.showAlert(title: "Failed to find the location", message: "\(error!)")
                    return
            }
            print("%%%%  CLGeocoder() return the placemarks: \(placemarks),\(location)")

            self.mapView.removeAnnotations(self.mapView.annotations)
            var annotations : [MKPointAnnotation] = []
            self.newInfo.lat = location.coordinate.latitude
            self.newInfo.lon = location.coordinate.longitude
            self.newInfo.key = MapClientData.sharedInstance().userInfo.key
            self.newInfo.firstName = MapClientData.sharedInstance().userInfo.firstName
            self.newInfo.lastName = MapClientData.sharedInstance().userInfo.lastName
            self.newInfo.url = self.urlTextField.text!

//            print("$$$$  \(self.newInfo.lat) \(self.newInfo.lon)",error,placemarks,location)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "\(self.newInfo.firstName) \(self.newInfo.lastName)"
            annotation.subtitle = self.newInfo.url
            annotations.append(annotation)
            
            
            
            self.mapView.addAnnotations(annotations)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
//            print("@@@   in AddPins calling MapClient.sharedInstance().key ,",MapClient.sharedInstance().key)
            self.view.endEditing(true) //close keyboard

        }
        
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //to hide keyboard after tapping return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
    }

    func showAlert (title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
        print("####   showAlert got called")
    }
    



// MARK: Wire a button to the pin to bring up confirmation window

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        print("&&&   mapView viewFor annotation got called")
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.pinTintColor = UIColor.orange
        pinView!.canShowCallout = true
        pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        pinView!.leftCalloutAccessoryView = UIButton(type: .contactAdd)

        }
            
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("&&&   mapView annotationView view got called")
        if control == view.rightCalloutAccessoryView {
            print("$$$   control is at right")
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                var stringURL = toOpen
                if !stringURL.hasPrefix("http") {
                    stringURL = "https://"+stringURL
                }
                guard let url = URL(string:stringURL) else {
                    print("$$$  URL() return NIL")
                    return
                }
                app.open(url, options: [:], completionHandler: nil)
                
            }
        }
        if control == view.leftCalloutAccessoryView {
            print("$$$   control is at left")
            self.updateAlert(title: "Update", message: "OK to Update ?")
        }

    }
    
    //Alert view(two bottons) triggered by left callout at Pins
    @objc func updateAlert (title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        //Update button : to store personal info back to cloud
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()

            //MARK: update perosnoal info
            MapClient.sharedInstance().createInfo(key:self.newInfo.key, firstName: self.newInfo.firstName, lastName: self.newInfo.lastName,url: self.newInfo.url,lat:self.newInfo.lat,lon:self.newInfo.lon) {(data,error) in
                
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                // report error from dataTask like internet off
                guard let data = data else {
                let errorLocal = error?.localizedDescription
                    self.showAlert(title:"Update Failed", message: errorLocal!)
                    return
                }
                
                //report error message in return data
                guard let errorString = data["error"] else {
                    self.showAlert(title: "Update", message: "done. No errors")
                    return
                }
//                let dataEncoding = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                self.showAlert(title:"Update Failed", message: errorString as! String)
                print("$$$ Updat info to Parse and got error in return data")
                
            }
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)//back to tabview after successful update
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    deinit {
        print("&&&&&  AddPinsViewController got deallocated  ")
    }

}
