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
        MapClient.sharedInstance().parseGetLocations() {(success,errorString)->Void in
            
            // stop indicator
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
            guard success else {
                performUIUpdatesOnMain {
                    self.displayError(errorString!)
                }
                return
            }
            
            self.navigationController?.popToRootViewController(animated: true)

            
            
            print("@@@   refresh button got taped. the current VC is: \(self) , ")

//            let whoIsSelected = self.tabBarController?.selectedIndex
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

        }

    }
    
    @IBAction func addPins(_ sender: Any) {
        
        // Check if current studentLocations has the user's data already.
        print("####     addPins got tapped      ####")
        var repeatData = 0
        for student in MapClientData.sharedInstance().studentLocations {
            if student.key == MapClientData.sharedInstance().userInfo.key {
                repeatData += 1
                print("####   found the old data   ####")
                //                showAlert(title: "Update ?", message: "\(MapClientData.sharedInstance().userInfo.firstName) \(MapClientData.sharedInstance().userInfo.lastName), overwrite URL and Location ?")
                //            } else {
                ////                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddPinsNavigationController") as! UINavigationController
                //                let controller = self.storyboard!.instantiateViewController(withIdentifier: "addPinsViewController") as! AddPinsViewController
                //                self.present(controller, animated: true, completion: nil)
                ////                self.navigationController?.pushViewController(controller, animated: true)
                //            }
            }
        }
        if repeatData != 0 {
            print("####   found the old data   ####")
            self.showAlert(title: "Update ?", message: "\(MapClientData.sharedInstance().userInfo.firstName) \(MapClientData.sharedInstance().userInfo.lastName), overwrite URL and Location ?")
        } else {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddPinsNavigationController") as! UINavigationController

//            let controller = self.storyboard!.instantiateViewController(withIdentifier: "addPinsViewController") as! AddPinsViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //Alert view for user to confirm overwrite
    func showAlert (title:String,message:String) {
        print("#####    showAlert got called in tableView   ####")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddPinsNavigationController") as! UINavigationController
//            let controller = self.storyboard!.instantiateViewController(withIdentifier: "addPinsViewController") as! AddPinsViewController

            self.present(controller, animated: true, completion: nil)
//            self.navigationController?.pushViewController(controller, animated: true)

            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
//        print("####   showAlert got called")
    }

    
    @IBAction func logOut(_ sender: Any) {
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootVC = mainStoryboard.instantiateViewController(withIdentifier: "loginVC") as! UIViewController
//        UIApplication.shared.keyWindow?.rootViewController = rootVC
        MapClient.sharedInstance().UdacityDelSession() //delete session
        dismiss(animated: true, completion: nil)
    }
    
    // Display Error
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Message", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }

}


