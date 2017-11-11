//
//  StudentInfo.swift
//  On The Map
//
//  Created by sam on 11/3/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import Foundation

    // read in dirctionary and store 6 elements
    struct Student {
        var key : String
        var firstName : String
        var lastName : String
        var url : String
        var lat : Double
        var lon : Double
        
        // remove nil in return data
        init(dictionary: [String:AnyObject]) {
            if (dictionary["uniqueKey"] == nil) {key=""} else {
                key = dictionary["uniqueKey"] as! String
            }
            if (dictionary["firstName"] == nil) {firstName=""} else {
                firstName = dictionary["firstName"] as! String
            }
            if (dictionary["lastName"] == nil) {lastName=""} else {
                lastName = dictionary["lastName"] as! String
            }
            if (dictionary["mediaURL"] == nil) {url=""} else {
                url = dictionary["mediaURL"] as! String
            }
            if (dictionary["latitude"] == nil) {lat=0} else {
                lat = dictionary["latitude"] as! Double
            }
            if (dictionary["longitude"] == nil) {lon=0} else {
                lon = dictionary["longitude"] as! Double
            }
        }
        
        static func infoFromResults(_ results: [[String:AnyObject]]) -> [Student] {
            var studentsInfo = [Student]()
            for result in results {
                studentsInfo.append(Student(dictionary: result))
            }
            return studentsInfo
        }
    }

// store personal info from Udacity
struct Personal {
    
    var key = String()
    var lastName = String()
    var firstName = String()
    var lat = Double()
    var lon = Double()
    var url = String()
    
}
