//
//  UserInfoViewController.swift
//  On The Map
//
//  Created by Patrick on 10/22/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import UIKit
import MapKit


class UserInfoViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate  {
    
    @IBOutlet weak var mapSearchView: MKMapView!
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    let locationManager  = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self // set the current VC as the Location Manager delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        
        /*/MARK: setup tap Recognizer, don't work yet
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:Selector(("handleTap:")))
        gestureRecognizer.delegate = self
        mapSearchView.addGestureRecognizer(gestureRecognizer)

        func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
    
            let location = gestureReconizer.location(in: mapSearchView)
            let coordinate = mapSearchView.convert(location,toCoordinateFrom: mapSearchView)
    
            // Add annotation:
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapSearchView.addAnnotation(annotation)
        } */

        
        // Async,request locationn,once get location,call locationManager delegate method didUpdateLocations,there will be  2nd request after getting permission in delegate method locationManager(didChangeAuthorization).
        locationManager.requestLocation()
        

    }
}
// MARK:Location Manger,delegate methods for Protocol CLLocationManagerDelegate
extension UserInfoViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("$$$   return error when calling delegate method locationManager(didFailWithError), error:: \(error)")
    }
    
    // this only run at the very frist time right after user give permission.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation() // request again because 1st request was failed
            print("$$$   2nd call at locationManager.requestLocation()")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("$$$   location manager delegate didUpdateLocations got called by .requestLocation()")
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapSearchView.setRegion(region, animated: true)
        }
    }
    
    // MARK: mapView delegat to call out by tapping.
    
    // show pins in Map. right now the only annotation in mapView is the current location.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("$$$   mapView show pins delegate method viewFor annotation is called ",mapView.annotations,annotation.subtitle,annotation.coordinate,annotation.title)

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        // don't want to overwrite the current annotation.
        if pinView == nil {
            if annotation is MKUserLocation {
                //return nil. There is no any actions when annotation is the current location. so it will be still a blue dot instead of Pin
                return nil
            }

            let newAnnotation = MKPointAnnotation()
            newAnnotation.title = " modified current location"
            newAnnotation.subtitle = "www.google.com"
            newAnnotation.coordinate = annotation.coordinate
            
            print("$$$   pinView is nil",newAnnotation)
            pinView = MKPinAnnotationView(annotation: newAnnotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .orange
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView?.leftCalloutAccessoryView = UIButton(type: .infoLight)
            
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    // call out by tapping the pins
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("$$$   mapView call out delegate method calloutAccessoryControlTapped is called,right tap ")
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
//            if let toOpen = view.annotation?.subtitle! {
//                var stringURL = toOpen
                var stringURL = "www.google.com"
                if !stringURL.hasPrefix("http") {
                    stringURL = "https://"+stringURL
                }
                guard let url = URL(string:stringURL) else {
                    print("$$$  URL() return NIL")
                    return
                }
                print("$$$ url is :",url)
                app.open(url, options: [:], completionHandler: nil)
                
//            }
        }
    }

}

