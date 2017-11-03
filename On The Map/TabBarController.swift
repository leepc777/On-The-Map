//
//  TabBarController.swift
//  On The Map
//
//  Created by sam on 10/27/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func refresh(_ sender: Any) {
        print("$$$   tapping refresh button in tableViewController , calling loadView() ",self)
        MapClient.sharedInstance().parseGetLocations() {(returnData)->Void in
            let arrayReturn = returnData
            MapClient.sharedInstance().locations = arrayReturn["results"] as? [[String:AnyObject]]
            
            
            performUIUpdatesOnMain {
//                let nextVC = self
//            self.navigationController?.popToViewController(self, animated: true)
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
                
            }
        }

    }
    
    @IBAction func addPins(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddPinsNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    
}
