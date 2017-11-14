//
//  LoginViewController.swift
//  On The Map
//
//  Created by Patrick on 10/13/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextView: UITextView!
    
    let reachability = Reachability()!
    var activityIndicator = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let reachability = Reachability()!
        
        //set Reachability
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
//            displayError("Reachable via WiFi")
            print("%%%   Reachable via WiFi")
        case .cellular:
            print("%%%   Reachable via Cellular")
        case .none:
            print("%%%   Network not reachable")
//            displayError("Network not reachable")
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        // MARK: get session from udacity
        //need to provide userName and passWord

        //set up indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        
//        MapClient.sharedInstance().login(userName: nameTextField.text!, passWord: passwordTextField.text!) {(success,errorString)->Void in
        
        MapClient.sharedInstance().login(userName: "leepc777@gmail.com", passWord: "2114550a") {(success,errorString)->Void in

        
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()

                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString!)
                }

            }
            
        }
        
        
        
        
        
        
        
        /*
//        MapClient.sharedInstance().UdacityGetSession(userName: nameTextField.text!, passWord: passwordTextField.text!) {(returnData,error)->Void in

        MapClient.sharedInstance().UdacityGetSession(userName: "leepc777@gmail.com", passWord: "2114550a") {(returnData,error)->Void in
            
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
                    
            print("%%%%  VC request Udacity Session and got return data",returnData)
            
            // report error from dataTask. internet connection issues
            guard let returnData = returnData else {
                let errorLocalized = error?.localizedDescription as! String
                print("$$$$    dataTask failed at getting session,\(String(describing: errorLocalized)),\(error)")
                performUIUpdatesOnMain {
                    let error = errorLocalized
                    self.displayError("Login Failed: \(String(describing: error))!")
                }
                return
            }
            
            // report wrong account/password
            guard let account = returnData["account"] as? [String:AnyObject] else {
                performUIUpdatesOnMain {
                    let error = returnData["error"] as! String
                    self.displayError("Login Failed : \(error)")
                }
                return
            }
            
            //MARK: Get Key
            MapClient.sharedInstance().userInfo.key = account["key"] as! String
            let key = MapClient.sharedInstance().userInfo.key
            print("%%% the key is",key)
            
            //MARK: kill session after login
//            MapClient.sharedInstance().UdacityDelSession()
            
            //get public user data from Udacity,need to provide KEY
            MapClient.sharedInstance().UdacityPublicUserData(key: key) { (returnData) in
//                MapClient.sharedInstance().userInfo = returnData
//                self.userInfo = returnData
//                print("%%%  VC got the user info",self.userInfo)
                
                // MARK: get multiple locationS from Parse
                MapClient.sharedInstance().parseGetLocations() {(returnData,error)->Void in
                    
                    //report error from dataTask
                    guard let returnData = returnData else {
                        let errorLocalized = error?.localizedDescription as! String
                        print("$$$$    dataTask failed at getting locations,\(String(describing: errorLocalized))")
                        performUIUpdatesOnMain {
                            self.displayError("dataTask failed to get locations: \n \(errorLocalized)")
                        }
                        return
                    }
                    
                    print("@@@   the returnData for rquesting students:",returnData)
                    
                    //report error message inside the return data
                    guard let results = returnData["results"] as? [[String:AnyObject]] else {
                        performUIUpdatesOnMain {
                            let error = returnData["error"] as! String
                            self.displayError("Failed to get Locations : \(error)")
                        }
                        return
                    }
                    MapClient.sharedInstance().studentLocations = Student.infoFromResults(results)
                    print("@@@   use Stuct to store return students info",MapClient.sharedInstance().studentLocations)
                    
                    //                    print("%%%  VC got the Locations",self.locations)
                    
                    performUIUpdatesOnMain {
                        self.completeLogin()
                    }
                }
            }
        } */
    }
    
    
    // MARK: Login
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    
    // Display Error
    func displayError(_ error: String) {
//        self.debugTextView.text = "\n \(String(describing: error))"
        let alert = UIAlertController(title: "Message", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
//        print("$$$   ",error)
        
    }
    
}

