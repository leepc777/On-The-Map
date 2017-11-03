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

    
    var locations:[[String:AnyObject]]!
    
    // setup UISearchController variable, you can't set UISearchController in StoryBoard
    // here use same VC to search and show the result
    let searchController = UISearchController(searchResultsController: nil)
    var filteredData:[[String:AnyObject]]!

//    var isFiltering() = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = MapClient.sharedInstance().locations
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self // set self as the deleagate
        searchController.obscuresBackgroundDuringPresentation = false//table view can still scroll up/down when searching
        searchController.searchBar.placeholder = "Search First Name"
        
        //this prevent view to hide search bar when keyboard shows up
        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.dimsBackgroundDuringPresentation = true
        
        //make search bar show in naviationItem
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


    // MARK: - Table view data source delegate method

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("%%%   numberOfSections was called")
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("%%%  numberOfRowsInSection was called, the tableView is:",tableView,"setction is :",section,"location count:",locations.count)
        if isFiltering() {
            return filteredData.count
        }
        return locations.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        // Configure the cell...
        var dictionary:[String:AnyObject] = [:]
        var firstName=String()
        var lastName=String()
        var mediaURL:String
        if isFiltering() {
            dictionary = filteredData[indexPath.row]
            
        } else {
            dictionary = locations[indexPath.row]
        }
        
        if (dictionary["firstName"] == nil) {firstName=""} else { firstName = dictionary["firstName"] as! String }
        if (dictionary["lastName"] == nil) {lastName=""} else {lastName = dictionary["lastName"] as! String}
        if (dictionary["mediaURL"] == nil) {mediaURL=""} else{ mediaURL = dictionary["mediaURL"] as! String}
        cell.textLabel?.text = "\(firstName) \(lastName)"
//        cell.textLabel?.text = firstName+" "+lastName
        cell.detailTextLabel?.text = mediaURL
//        print("$$$    populate data to table cell: cellForRowAt :",dictionary!["mediaURL"]!)
        return cell
    }
    
    // after tapping the cell, read out and open url
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dictionary = locations[indexPath.row]
        var dictionary:[String:AnyObject] = [:]
        if isFiltering() {
            dictionary = filteredData[indexPath.row]
            
        } else {
            dictionary = locations[indexPath.row]
        }

//        print("$$$   in didSelectRow, the dictionary is :",dictionary,"stringURL is:",dictionary["mediaURL"], type(of:dictionary["mediaURL"]))

        guard var stringURL = dictionary["mediaURL"] as? String else {
            print("$$$  stringuURL is nil")
            return
        }
        
        // replacing www with https://www because seems openurl require URL start wtih http so it cant open like google.com or www.google.com

        if !stringURL.hasPrefix("http") {
            stringURL = "https://"+stringURL
        }
        guard let url = URL(string:stringURL) else {
//        guard let url = URL(string:"https://www.udacity.com") else {

            print("$$$  URL() return NIL")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
//    //MARK: Refresh Table
//
//    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
//        tableView.reloadData()
//        print("$$$   refresh button got tapped and refresh viewTble")
//    }

}


//  MARK: UISeawrController will call this delegate method when searching bar is 1stresponder.
//ListTableVC is the delegate and conform UISearchResultsUpdating
extension ListTableViewController: UISearchResultsUpdating {

    // MARK: - UISearchResultsUpdating Delegate Method
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        print("%%%   updateSearchResults() was called")
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
    // MARK: - Private instance methods
    
    /*
    custom function to search/replace. be called in the delegate method updateSearchResults
    to search the element of array and return that element when closre return true. here closure return trun when the element(a dictionary)  contains searchText
   */
    
    func filterContentForSearchText(_ searchText: String) {
        filteredData = self.locations.filter({( locationDictionary : [String:AnyObject]) -> Bool in
            guard let firstName = locationDictionary["firstName"] as? String else {
                print("%%%   name is empty in locationDictionary")
                return false
            }
            
            return firstName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        print("%%%   filterContentForSearchText() was called")
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        print("%%%   searchBarIsEmpty() was called")
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        print("%%%   isFiltering() was called and return :",searchController.isActive && !searchBarIsEmpty())
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
