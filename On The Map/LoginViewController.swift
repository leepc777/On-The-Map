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
    
    var name:String!
    var key:String!
    var website_url:String!
    var userInfo:[String:AnyObject]!
    let reachability = Reachability()!
//    var locations:[AnyObject]!
//    var locations:[[String:AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let reachability = Reachability()!
        
        //declare this inside of viewWillAppear
        
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
        
        // get session from udacity , need to provide userName and passWord

        MapClient.sharedInstance().UdacityGetSession(userName: nameTextField.text!, passWord: passwordTextField.text!) {(returnData,error)->Void in
        
//        MapClient.sharedInstance().UdacityGetSession(userName: "", passWord: "") {(returnData)->Void in
        

            print("%%%%  VC request Udacity Session and got return data",returnData)
            guard let returnData = returnData else {
                let errorLocalized = error?.localizedDescription
                print("$$$$    dataTask failed,\(String(describing: errorLocalized))")
                performUIUpdatesOnMain {
                    let error = errorLocalized
                    self.displayError(error!)
                }
                return
            }
            
            guard let account = returnData["account"] as? [String:AnyObject] else {
                performUIUpdatesOnMain {
                    let error = returnData["error"]!
                    self.displayError(error as! String)
                }
                return
            }
            
            //Get Key
            MapClient.sharedInstance().key = account["key"] as! String
            self.key = MapClient.sharedInstance().key
            print("%%% the key is",self.key)
            
            //kill session after login
            MapClient.sharedInstance().UdacityDelSession()
            
            //get public user data from Udacity,need to provide KEY
            MapClient.sharedInstance().UdacityPublicUserData(key: self.key) { (returnData) in
//                MapClient.sharedInstance().userInfo = returnData
                self.userInfo = returnData
//                print("%%%  VC got the user info",self.userInfo)
                
                // get multiple locationS from Parse
                MapClient.sharedInstance().parseGetLocations() {(returnData)->Void in
                    let arrayReturn = returnData
                    MapClient.sharedInstance().locations = arrayReturn["results"] as? [[String:AnyObject]]
                    
                    let results = arrayReturn["results"] as? [[String:AnyObject]]
                    MapClient.sharedInstance().studentLocations = Student.infoFromResults(results!)
                    print("@@@   use Stuct to store return students info",MapClient.sharedInstance().studentLocations)
                    
                    //                    print("%%%  VC got the Locations",self.locations)
                    
                    performUIUpdatesOnMain {
                        self.completeLogin()
                    }
                }
            }
        }
    }
    
    
    // MARK: Login
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    
    // Display Error
    func displayError(_ error: String) {
        self.debugTextView.text = " Login Failed. \n \(String(describing: error))"
        print("$$$   ",error)
        
    }


}

