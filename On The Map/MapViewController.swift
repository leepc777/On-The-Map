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
//        var annotations = [MKPointAnnotation()]
//        var annotationsNew = [MKPointAnnotation]()
//        // looping the array locations and store the information to MKPointAnnotation() Type array
//
//        //MARK: set up annotations with [Struct] array instead
//        for studentLocation in MapClient.sharedInstance().studentLocations {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.lat, longitude: studentLocation.lon)
//            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
//            annotation.subtitle = studentLocation.url
//            // Finally we place the annotation in an array of annotations.
//            annotationsNew.append(annotation)
//        }
//
//
//        // When the array is complete, we add the annotations to the map.
//        // MARK: add array of pins to map(var annotations : [MKPointAnnotation()])
//        mapView.addAnnotations(annotationsNew)
//
//        print("####    in MapViewController , mapView.annotations is ", mapView.annotations)
    }
    // want to refresh the Pins on map with every time when MapView shows
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        mapView.reloadInputViews()
        var annotationsNew = [MKPointAnnotation]()
        // looping the array locations and store the information to MKPointAnnotation() Type array
        
        //MARK: set up annotations with [Struct] array instead
        for studentLocation in MapClient.sharedInstance().studentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.lat, longitude: studentLocation.lon)
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.url
            // Finally we place the annotation in an array of annotations.
            annotationsNew.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotationsNew)

        print("&&&   MapView viewWillAppear got called")
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
    
    
    // MARK: This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    
    // Options are specified in the section below for openURL options. An empty options dictionary will result in the same
    // behavior as the older openURL call, aside from the fact that this is asynchronous and calls the completion handler rather
    // than returning a result.
    // The completion handler is called on the main queue.
//    @available(iOS 10.0, *)
//    open func open(_ url: URL, options: [String : Any] = [:], completionHandler completion: ((Bool) -> Swift.Void)? = nil)

    
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
                    return
                }
                app.open(url, options: [:], completionHandler: nil)

            }
        }
    }
    
}

extension MapViewController : RefreshTab {
    func refresh() {
        print("$$$   delegate method refresh got called,current VC: is \(self)")
        performUIUpdatesOnMain {
            print("&&&&    delegat method refresh in MapVC got call ")
            //        mapView.reloadInputViews()
            var annotationsNew = [MKPointAnnotation]()
            // looping the array locations and store the information to MKPointAnnotation() Type array
            
            //MARK: set up annotations with [Struct] array instead
            for studentLocation in MapClient.sharedInstance().studentLocations {
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

