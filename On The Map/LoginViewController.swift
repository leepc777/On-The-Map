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
//    var locations:[AnyObject]!
//    var locations:[[String:AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginPressed(_ sender: Any) {
        
//        MapClient.sharedInstance().UdacityGetSession(userName: nameTextField.text!, passWord: passwordTextField.text!) {(xxx)->Void in
        
        // get session from udacity , need to provide userName and passWord
        MapClient.sharedInstance().UdacityGetSession(userName: "leepc777@gmail.com", passWord: "2114550a") {(returnData)->Void in

            print("%%%%  VC got the data",returnData)
            let account = returnData["account"] as? [String:AnyObject]
//            self.key = account!["key"] as! String
            MapClient.sharedInstance().key = account!["key"] as! String
            self.key = MapClient.sharedInstance().key
            print("%%% the key is",self.key)
            
            //kill session after login
            MapClient.sharedInstance().UdacityDelSession()
            
            //get public user data from Udacity , need to provide user's KEY
            MapClient.sharedInstance().UdacityPublicUserData(key: self.key) { (returnData) in
                MapClient.sharedInstance().userInfo = returnData
                self.userInfo = returnData
                print("%%%  VC got the user info",self.userInfo)
                
                // get multiple locationS from Parse
                MapClient.sharedInstance().parseGetLocations() {(returnData)->Void in
                    let arrayReturn = returnData
//                    self.locations = arrayReturn!["results"] as? [AnyObject]
//                    self.locations = arrayReturn!["results"] as? [[String:AnyObject]]
//                    MapClient.sharedInstance().locations = self.locations
                    MapClient.sharedInstance().locations = arrayReturn["results"] as? [[String:AnyObject]]

//                    print("%%%  VC got the Locations",self.locations)
                    
                performUIUpdatesOnMain {
                    self.debugTextView.text = "self.userInfo as? String"
                    self.completeLogin()
                    self.debugTextView.text = "self.userInfo as? String"

                }
            }
            }
            
//            performUIUpdatesOnMain {
//                self.completeLogin()
//            }
        }
    }
    
    
    // MARK: Login
    private func completeLogin() {
        self.debugTextView.text = "you are in completetion()"
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    

}

