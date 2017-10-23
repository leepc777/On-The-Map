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
    let searchController = UISearchController(searchResultsController: nil)
    var filteredData:[[String:AnyObject]]!

//    var isFiltering() = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locations = MapClient.sharedInstance().locations
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Map"
        navigationItem.searchController = searchController //show searchbar in VC
        definesPresentationContext = true


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

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
        if isFiltering() {
            dictionary = filteredData[indexPath.row]
            
        } else {
            dictionary = locations[indexPath.row]
        }
        
        firstName = (dictionary["firstName"] as? String)!
        lastName = (dictionary["lastName"] as? String)!
        cell.textLabel?.text = firstName+" "+lastName
        cell.detailTextLabel?.text = dictionary["mediaURL"] as? String
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

        print("$$$   in didSelectRow, the dictionary is :",dictionary,"stringURL is:",dictionary["mediaURL"], type(of:dictionary["mediaURL"]))

        guard var stringURL = dictionary["mediaURL"] as? String else {
            print("$$$  stringuURL is nil")
            return
        }
        
        // replacing www with https://www because seems openurl require URL star wtih http so it cant open like google.com or www.google.com
//        if stringURL.hasPrefix("www") {
//            print("$$$   stringURL starts with www instead of https://www ")
//            stringURL=stringURL.replacingOccurrences(of: "www", with: "https://www")
//        }
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
    
}

extension ListTableViewController: UISearchResultsUpdating {

    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        print("%%%   updateSearchResults() was called")
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        print("%%%   searchBarIsEmpty() was called")
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // search the element of array and return true when there is a hit  -candy.name contains searchText
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
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
    
    func isFiltering() -> Bool {
        print("%%%   isFiltering() was called and return :",searchController.isActive && !searchBarIsEmpty())
        return searchController.isActive && !searchBarIsEmpty()
    }

}
