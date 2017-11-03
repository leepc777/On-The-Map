//
//  MapClient.swift
//  On The Map
//
//  Created by Patrick on 10/14/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import Foundation
// MARK: - MapClient: NSObject

class MapClient : NSObject {
    
    // MARK: global vairables to store data
//    var userName:String = ""
//    var passWord:String = ""
    

    var studentLocations : [Student]!
    var key:String!
    var locations:[[String:AnyObject]]!
    var userInfo:[String:AnyObject]!
    var firstName : String!
    var lastName : String!
    
//    var dictionary:[String:AnyObject]!
    
    // MARK: Udacity get a session
    func UdacityGetSession(userName:String,passWord:String,UdacityGetSessionCompletionHandler:@escaping ([String:AnyObject]?,Error?)->Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(passWord)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            
            if error != nil { // Handle error…
                let errorMessage = error?.localizedDescription
                let errorDebug = error.debugDescription
                self.displayError ("$$$  get a session fail,\(error),\(errorMessage),\(errorDebug)")
                UdacityGetSessionCompletionHandler(nil,error)
                    return
                }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            //Parse Data
            let finalData = self.parseJSON(data: newData!)
            UdacityGetSessionCompletionHandler(finalData,nil) //pass clean data to closure
        
            print("$$$   ",NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            print("$$$ get sessiion and the return data is :",finalData, type(of: finalData))
        }
        task.resume()

        
    }
    
    // MARK: Udacity delete a session after log in
    func UdacityDelSession () {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                self.displayError ("$$$  kill a session fail,")
                return
            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
        
    }
    
    
    // MARK: Udacity get public User data
    func UdacityPublicUserData(key:String,UdacityPublicUserDataCompletionHandler: @escaping ([String:AnyObject])->Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                self.displayError ("$$$  fail to get user data ")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            //Parse Data
            let finalData = self.parseJSON(data: newData!)
            self.userInfo = finalData["user"] as? [String:AnyObject]
            self.lastName = self.userInfo["last_name"] as! String
            self.firstName = self.userInfo["first_name"] as! String
//            print("$$$  public info from Udacity, firstName, LastName, Key", self.firstName,self.lastName,self.key)
            UdacityPublicUserDataCompletionHandler(self.userInfo) //pass clean data to closure
//            print("&&&   Udacity API get public Data",NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }

    // MARK: Parse API : get multiple student locations
    func parseGetLocations(parseGetLocationsCompletionHandler: @escaping ([String:AnyObject])->Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=3")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                self.displayError ("$$$  failed to get multiple locations ")
                return
            }
//            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            //Parse data
            let finalData = self.parseJSON(data: data!)
            parseGetLocationsCompletionHandler(finalData)
        }
        task.resume()

    }
    
    // MARK: create info for a student based on key
    func createInfo(key:String,firstName:String,lastName:String,url:String,lat:Double,lon:Double) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let firstName = self.firstName
//        let lastName = self.lastName
        request.httpBody = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"San Jose, CA\", \"mediaURL\": \"\(url)\",\"latitude\": \(lat), \"longitude\": \(lon)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                self.displayError("fail to creat info for a student")
                return
            }
            print("&&&  call NSMutableURLRequest to create info for a student  ", self.firstName,self.lastName,self.key,NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }

    // Display Error
    
    func displayError(_ error: String) {
        print("$$$   ",error)
        
    }
    
    // Parse JSON data
    
    func parseJSON (data:Data) -> [String:AnyObject] {
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            
            displayError("$$$  Could not parse the data as JSON: '\(data)'")
            return [:]
        }
        return parsedResult
    }
    // MARK: Shared Instance
    
    class func sharedInstance() -> MapClient {
        struct Singleton {
            static var sharedInstance = MapClient()
        }
        return Singleton.sharedInstance
    }
}
