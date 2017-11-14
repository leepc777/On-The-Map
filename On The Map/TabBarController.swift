//
//  TabBarController.swift
//  On The Map
//
//  Created by sam on 10/27/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import UIKit



class TabBarController: UITabBarController {
    
    var myDelegateTable:RefreshTab?=nil
    var myDelegateMap:RefreshTab?=nil

    var activityIndicator = UIActivityIndicatorView()
    
//    @IBAction func unWindSegueToTab(_ sender : UIStoryboardSegue) {
//        print("^^^^  unwindSegue got called")
//    }

    @IBAction func refresh(_ sender: Any) {
        print("$$$   tapping refresh button in tableViewController , calling loadView() ",self)
        
        //set up indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // refresh button to get locations form cloud
        MapClient.sharedInstance().parseGetLocations() {(returnData,error)->Void in
            
            // stop indicator
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                /*//change root to tab bar controller.
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let rootVC = mainStoryboard.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = rootVC */
            }
            guard let returnData = returnData else {
                let errorLocalized = error?.localizedDescription
                print("$$$$    dataTask failed at getting locations,\(String(describing: errorLocalized))")
                return
            }
            
            print("@@@   the returnData for rquesting students:",returnData)
            
            guard let results = returnData["results"] as? [[String:AnyObject]] else {
                return
            }
            
            MapClient.sharedInstance().studentLocations = Student.infoFromResults(results)
            
            self.navigationController?.popToRootViewController(animated: true)

            
//            self.dismiss(animated: true, completion: nil)
            
////            let whoIsSelected = self.tabBarController?.selectedIndex
            print("@@@   refresh button got taped. the current VC is: \(self) , ")

            
//            let selectedVC = self.tabBarController?.selectedViewController
//            let selectedIndex = self.tabBarController?.selectedIndex
//            let barViewControllers = self.tabBarController?.viewControllers
//            let selectedVC = self.selectedViewController?.target(forAction: <#T##Selector#>, withSender: <#T##Any?#>)

            let selectedVC = self.selectedViewController
            let selectedIndex = self.selectedIndex
            let barViewControllers = self.viewControllers
            let sss = selectedVC!
            let vc = self.viewControllers![1]
            vc.resignFirstResponder()
            

            print("$$$$ print barViewControllers is \(barViewControllers) ",selectedVC,sss,selectedIndex,vc)
            self.myDelegateTable?.refresh()
            self.myDelegateMap?.refresh()
            
//            let tableVC = barViewControllers![1] as! ListTableViewController
//            tableVC.refreshTable()

//            performUIUpdatesOnMain {
//                let tableVC = ListTableViewController()
//                tableVC.refreshTable()
//                self.view.addSubview(tableVC)
//            }
            
            
//            self.tabBar.reloadInputViews()
//            self.refresh((Any).self)

        }

    }
    
    @IBAction func addPins(_ sender: Any) {
        
        // Check if current studentLocations has the user's data already.
        for student in MapClient.sharedInstance().studentLocations {
            if student.key == MapClient.sharedInstance().userInfo.key {
                showAlert(title: "Update ?", message: "\(MapClient.sharedInstance().userInfo.firstName) \(MapClient.sharedInstance().userInfo.lastName), overwrite URL and Location ?")
            } else {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddPinsNavigationController") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            }
        }
//        let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddPinsNavigationController") as! UINavigationController
//        self.present(controller, animated: true, completion: nil)
    }
    
    //Alert view for user to confirm overwrite
    func showAlert (title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddPinsNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)

            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        print("####   showAlert got called")
    }

    
    @IBAction func logOut(_ sender: Any) {
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootVC = mainStoryboard.instantiateViewController(withIdentifier: "loginVC") as! UIViewController
//        UIApplication.shared.keyWindow?.rootViewController = rootVC
//        MapClient.sharedInstance().UdacityDelSession() //delete session
        dismiss(animated: true, completion: nil)
    }
}


