//
//  TabBarController.swift
//  On The Map
//
//  Created by sam on 10/27/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import UIKit



class TabBarController: UITabBarController {
    
//    var myDelegateTable:RefreshTab?=nil
//    var myDelegateMap:RefreshTab?=nil

//    var myDelegateTable:RefreshTab!
//    var myDelegateMap:RefreshTab!

    
    // set delegate properties
    var myDelegateTable:RefreshTab?
    var myDelegateMap:RefreshTab?

    
    var activityIndicator = UIActivityIndicatorView()
    

    @IBAction func refresh(_ sender: Any) {
        print("$$$   tapping refresh button in tabBarController",self)
        
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
            
            
            //MARK: ask delegate(ChildViews:TableVC/MapVC) to run delegate mehod to refresh
            self.myDelegateTable?.refresh()
            self.myDelegateMap?.refresh()
            //self.myDelegateTable.refresh() //fail if myDelegateTable is Nil
            //self.myDelegateMap.refresh()

            
            
            //tests to see if I can refersh childViews from tabbarVC
//            self.navigationController?.popToRootViewController(animated: true)

            
            
//            print("@@@   refresh button got taped. the current VC is: \(self) , ")


            let selectedVC = self.selectedViewController
            let selectedIndex = self.selectedIndex
            let barViewControllers = self.viewControllers
            let sss = selectedVC!
            let vc = self.viewControllers![0]
//            vc.resignFirstResponder()
            
            

            print("$$$$ print barViewControllers is \(barViewControllers) ",selectedVC,sss,selectedIndex,vc)
            

            
//            let tableVC = barViewControllers![1] as! ListTableViewController
//            let tableVC = barViewControllers![1] as! ListTableViewController
            //2017-11-19 06:39:07.012504-0800 On The Map[369:205120] Could not cast value of type 'UINavigationController' (0x1b61a9048) to 'On_The_Map.ListTableViewController' (0x100db6048).

//            tableVC.refresh()
        }

    }
    
    @IBAction func addPins(_ sender: Any) {
        
        // Check if current studentLocations has the user's data already.
//        print("####     addPins got tapped      ####")
        var repeatData = 0
        for student in MapClientData.sharedInstance().studentLocations {
            if student.key == MapClientData.sharedInstance().userInfo.key {
                repeatData += 1
//                print("####   found the old data   ####")
            }
        }
        if repeatData != 0 {
//            print("####   found the old data   ####")
            self.showAlert(title: "Update ?", message: "\(MapClientData.sharedInstance().userInfo.firstName) \(MapClientData.sharedInstance().userInfo.lastName), overwrite URL and Location ?")
        } else {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddPinsNavigationController") as! UINavigationController

//            let controller = self.storyboard!.instantiateViewController(withIdentifier: "addPinsViewController") as! AddPinsViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //Alert view for user to confirm overwrite
    func showAlert (title:String,message:String) {
//        print("#####    showAlert got called in tableView   ####")
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


