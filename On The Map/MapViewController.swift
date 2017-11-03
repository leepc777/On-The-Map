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
    var locations:[[String:AnyObject]]!
    let reachability = Reachability()!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = MapClient.sharedInstance().locations
        
        // creat a array of Class MKPointAnnotation() to store information. each element is a student
//        var annotations = [MKPointAnnotation()]
        var annotations = [MKPointAnnotation]()

        // looping the array locations and store the information to MKPointAnnotation() Type array
        for dictionary in locations {
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
        
            var lat: Double
            var long: Double
            var mediaURL:String
            var first:String
            var last:String
            
            if (dictionary["latitude"] == nil || dictionary["longitude"] == nil) {
                lat = 0
                long = 0
            } else {
                lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                long = CLLocationDegrees(dictionary["longitude"] as! Double)
            }
            
            // The lat and long numbers are used to create a CLLocationCoordinates2D instance.
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            if (dictionary["firstName"] == nil) {first=""} else { first = dictionary["firstName"] as! String }
            if (dictionary["lastName"] == nil) {last=""} else {last = dictionary["lastName"] as! String}
            if (dictionary["mediaURL"] == nil) {mediaURL=""} else{ mediaURL = dictionary["mediaURL"] as! String}
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            // When the array is complete, we add the annotations to the map.
            //        self.mapView.addAnnotations(annotations)
//            mapView.addAnnotations(annotations)
            
//            print("$$$$ annotations (array of MKPointAnnotation Type) is ",annotations)
//            print("$$$$ annotations ",annotations[0],annotations.last?.coordinate)
        }
        
        // MARK: add array of pins(var annotations : [MKPointAnnotation()])
        mapView.addAnnotations(annotations)
        print("####    in MapViewController , mapView.annotations is ", mapView.annotations)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("^^^^^    Reachable via WiFi")
        case .cellular:
            print("^^^^^    Reachable via Cellular")
        case .none:
            print("^^^^^    Network not reachable")
        }
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
