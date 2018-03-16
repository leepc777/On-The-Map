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
        nameTextField.placeholder = "User Email"
        nameTextField.keyboardType = UIKeyboardType.emailAddress
        nameTextField.autocorrectionType = UITextAutocorrectionType.yes

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
                
                self.activityIndicator.stopAnimating() //stop indicator
                UIApplication.shared.endIgnoringInteractionEvents()

                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString!)
                }
            }
        }
    }
    
    
    // MARK: Login
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
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

