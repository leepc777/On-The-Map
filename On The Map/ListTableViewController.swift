//
//  ListTableViewController.swift
//  On The Map
//
//  Created by sam on 10/14/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
//    class ListTableViewController: UITableViewController,UISearchBarDelegate, UISearchDisplayDelegate {

    // MARK: setup UISearchController in same VC
    // can't set UISearchController in StoryBoard

    let searchController = UISearchController(searchResultsController: nil)
//    var filteredDataNew:[Student]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        refreshTable()
        let tbvc = self.tabBarController as! TabBarController
        tbvc.myDelegateTable = self
//        tbvc.navigationController?.setToolbarHidden(true, animated: true)
//        subscribeToNotification(.UIViewControllerShowDetailTargetDidChange, selector: #selector(self.refreshTable))
        
////        let barViewControllers = self.tabBarController?.viewControllers
////        let tableVC = barViewControllers![1] as! ListTableViewController
        
//        let barViewControllers = self.tabBarController?.viewControllers
//        print("$$$$ print barViewControllers is \(barViewControllers) ")
//        let tableVC = barViewControllers![1] as! ListTableViewController
//        tableVC.refreshTable()
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self // set self as the deleagate
        searchController.obscuresBackgroundDuringPresentation = false//table view can still scroll up/down when searching
        searchController.searchBar.placeholder = "Search Name"
        
        //Don't hide search bar when keyboard shows up
        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.dimsBackgroundDuringPresentation = true
        
        //Show search bar in naviationItem
        navigationItem.searchController = searchController
//        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
       /* //more setup for search controller
        let sarchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
         */

        

    }

    /* life cycle for debug
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tableView.reloadData()
//        refreshTable()
        print("&&&   tableView viewWillAppear got called")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("&&&,    tableView viewWillDisappear got called")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("&&&,    tableView viewDidlDisappear got called")
    }
    

    override func viewDidAppear(_ animated: Bool) {
        //self.tableView.reloadData()
        print("$$$$    TableViewVC viewDidAppear got called        ")
    } */


    // MARK: - Table view data source delegate method

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("%%%   numberOfSections was called")
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("%%%  numberOfRowsInSection was called, the tableView is:",tableView,"setction is :",section)
        if isFiltering() {
            return MapClientData.sharedInstance().filteredDataNew.count
        }
        return MapClientData.sharedInstance().studentLocations.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        // Configure the cell...
        var dictionaryNew:Student!
        if isFiltering() {
            dictionaryNew = MapClientData.sharedInstance().filteredDataNew[indexPath.row]
        } else {
            dictionaryNew = MapClientData.sharedInstance().studentLocations[indexPath.row]
        }
        
        
//        print("$$$    populate data to table cell: cellForRowAt :",dictionary!["mediaURL"]!)
        cell.textLabel?.text = "\(dictionaryNew.firstName) \(dictionaryNew.lastName)"
        cell.detailTextLabel?.text = dictionaryNew.url
        return cell
    }
    
    // after tapping the cell, read out and open url
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let dictionary = locations[indexPath.row]
        var dictionaryNew:Student!
        if isFiltering() {
            dictionaryNew = MapClientData.sharedInstance().filteredDataNew[indexPath.row]
        } else {
            dictionaryNew = MapClientData.sharedInstance().studentLocations[indexPath.row]
        }
        
        //deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        //        print("$$$   in didSelectRow, the dictionary is :",dictionary,"stringURL is:",dictionary["mediaURL"], type(of:dictionary["mediaURL"]))
        
        let app = UIApplication.shared
        var stringURL = dictionaryNew.url
        if !stringURL.hasPrefix("http") {
            stringURL = "https://"+stringURL
        }
        guard let url = URL(string:stringURL) else {
            print("$$$  URL() return NIL")
            displayError("Not a valid URL")
            return
        }
        app.open(url, options: [:], completionHandler: nil)
    }
    
//    // MARK: custom func to reload table
//    @objc func refreshTable() {
//        print("$$$   refreshTable func got called,current VC: is \(self)")
//        tableView.reloadData()
//    }
    
    // Display Error in Alert
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Message", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    deinit {
        print("&&&&&  TableViewController got delocated  &&&&&")
    }

}


//  MARK: UISeawrController will call this delegate method when searching bar is 1stresponder.
//ListTableVC is the delegate and conform UISearchResultsUpdating
extension ListTableViewController: UISearchResultsUpdating {

    // MARK: - UISearchResultsUpdating Delegate Method
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        print("%%%   updateSearchResults() was called")
        filterContentForSearchTextNew(searchController.searchBar.text!)
        
    }
    
    // MARK: - Private instance methods
    
    /*
    custom function to search/replace. be called in the delegate method updateSearchResults
    to search the element of array and return that element when closre return true. here closure return trun when the element(a dictionary)  contains searchText
   */
    
    
    func filterContentForSearchTextNew(_ searchText: String) {
        MapClientData.sharedInstance().filteredDataNew = MapClientData.sharedInstance().studentLocations.filter({( studentLocation : Student) -> Bool in
           let name = studentLocation.firstName + studentLocation.lastName
            return name.lowercased().contains(searchText.lowercased())

        })
        
        tableView.reloadData()
        print("%%%   filterContentForSearchTextNew() was called")
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        print("%%%   searchBarIsEmpty() was called")
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
//        print("%%%   isFiltering() was called and return :",searchController.isActive && !searchBarIsEmpty())
        return searchController.isActive && !searchBarIsEmpty()
    }

    /* this is for putting searching bar in the table view header. Not done yet
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            
            view.endEditing(true)

            
            tableView.reloadData()
            
        } else {
            
            inSearchMode = true
            
            filteredData = data.filter({$0 == searchBar.text})
            
            tableView.reloadData()
        }
    } */

}
 /* set up notification
private extension ListTableViewController {
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
*/

protocol RefreshTab {
    func refresh()
}

extension ListTableViewController : RefreshTab {
    func refresh() {
            print("$$$   delegate method refresh got called,current VC: is \(self)")
        performUIUpdatesOnMain {
            self.tableView.reloadData()
        }
    }
}



