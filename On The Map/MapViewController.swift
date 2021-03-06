//
//  MapViewController.swift
//  On The Map
//
//  Created by Patrick on 10/14/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! TabBarController
        tbvc.myDelegateMap = self
//        self.tabBarController?.navigationController?.hidesBarsOnTap = true
        
        // creat a array of Class MKPointAnnotation() to store information. each element is a student
//      //  var annotations = [MKPointAnnotation()]
        var annotationsNew = [MKPointAnnotation]()
        // looping the array locations and store the information to MKPointAnnotation() Type array

        //MARK: set up annotations with [Struct] array instead
        for studentLocation in MapClientData.sharedInstance().studentLocations {
        // [Class] also works fine.
//        for studentLocation in MapClientData.sharedInstance().studentlocationsClass {
        
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.lat, longitude: studentLocation.lon)
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.url
            // Finally we place the annotation in an array of annotations.
            annotationsNew.append(annotation)
        }


        // When the array is complete, we add the annotations to the map.
        // MARK: add array of pins to map(var annotations : [MKPointAnnotation()])
        mapView.addAnnotations(annotationsNew)
//        print("####    in MapViewController , mapView.annotations is ", mapView.annotations)
    }
    
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        // don't want to overwrite the current annotation.
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
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
                    displayError("Not a valid URL")
                    return
                }
                app.open(url, options: [:], completionHandler: nil)

            }
        }
    }
    
    // Display Error in Alert
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Message", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}


// MARK: delegate method, refresh Map
extension MapViewController : RefreshTab {
    func refresh() {
        print("$$$   delegate method refresh in mapView got called,current VC: is \(self)")
        performUIUpdatesOnMain {
            print("&&&&    delegat method refresh in MapVC got call ")
            //        mapView.reloadInputViews()
            var annotationsNew = [MKPointAnnotation]()
            // looping the array locations and store the information to MKPointAnnotation() Type array
            
            //MARK: set up annotations with [Struct] array instead
            for studentLocation in MapClientData.sharedInstance().studentLocations {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.lat, longitude: studentLocation.lon)
                annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                annotation.subtitle = studentLocation.url
                // Finally we place the annotation in an array of annotations.
                annotationsNew.append(annotation)
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotationsNew)

        }
    }
    
}

