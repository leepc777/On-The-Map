//
//  MapClient.swift
//  On The Map
//
//  Created by Patrick on 10/14/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import Foundation
// MARK: - MapClient: NSObject , a Singleton
// MapClient is a Singleton storing global vairables and methods


class MapClient : NSObject {

    // students info (100 students)
    var studentLocations : [Student]!
    
    // user info ( one person )
    var userInfo = Personal()

        
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
            //pass Parsed data to closure
            UdacityGetSessionCompletionHandler(finalData,nil)
        
//            print("$$$   ",NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
//            print("$$$ get sessiion and the return data is :",finalData, type(of: finalData))
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
    
    
    // MARK: Udacity get public User data( One person )
    func UdacityPublicUserData(key:String,UdacityPublicUserDataCompletionHandler: @escaping (Personal)->Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                self.displayError ("$$$  fail to get user data ")
                return
            }
            
            guard let data = data else {
//                print("$$$  failed to get personal Info from Udacity")
                self.displayError ("$$$  failed to get personal Info from Udacity")
                return
            }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            //Parse Data
            let finalData = self.parseJSON(data: newData)
            let userData = finalData["user"] as? [String:AnyObject]
            self.userInfo.lastName = userData!["last_name"] as! String
            self.userInfo.firstName = userData!["first_name"] as! String
            self.userInfo.key = userData!["key"] as! String
            UdacityPublicUserDataCompletionHandler(self.userInfo) //pass clean data to closure

//            print("$$$  public personal info from Udacity, firstName, LastName, Key", self.firstName,self.lastName,self.key,finalData)
//            print("&&&   Udacity API get personal public Data",NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }

    // MARK: Parse API : get multiple student locations
    func parseGetLocations(parseGetLocationsCompletionHandler: @escaping ([String:AnyObject]?,Error?)->Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=3&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                self.displayError ("$$$  failed to get multiple locations ")
                let errorLocalized = error?.localizedDescription as! String
                parseGetLocationsCompletionHandler(nil,error)
                print("$$$  error from dataTask and localized error ",error,errorLocalized)
                return
            }
//            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            //Parse data
            let finalData = self.parseJSON(data: data!)
            parseGetLocationsCompletionHandler(finalData,nil)
        }
        task.resume()

    }
    
    // MARK: create info for a student based on key
    func createInfo(key:String,firstName:String,lastName:String,url:String,lat:Double,lon:Double,createInfoCompletionHandler:@escaping ([String:AnyObject]?,Error?)->Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"San Jose, CA\", \"mediaURL\": \"\(url)\",\"latitude\": \(lat), \"longitude\": \(lon)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                self.displayError("fail to creat info for a student")
                createInfoCompletionHandler(nil,error)
                return
            }
            print("&&&  call NSMutableURLRequest to create info for a student  ", self.userInfo.firstName,self.userInfo.lastName,self.userInfo.key,data!,NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
//            let dataEncoding = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            
            //Parse Data
            let finalData = self.parseJSON(data: data!)
            //pass Parsed data to closure
            createInfoCompletionHandler(finalData,nil)
            print("%%%%   createInfo got called and the return data", data,finalData)
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
