//
//  StudentInfo.swift
//  On The Map
//
//  Created by sam on 11/3/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import Foundation

    struct Student {
        var key : String
        var firstName : String
        var lastName : String
        var url : String
        var lat : Double
        var lon : Double
        
        init(dictionary: [String:AnyObject]) {
            key = dictionary["uniqueKey"] as! String
            firstName = dictionary["firstName"] as! String
            lastName = dictionary["lastName"] as! String
            url = dictionary["mediaURL"] as! String
            lat = dictionary["latitude"] as! Double
            lon = dictionary["longitude"] as! Double
        }
        
        static func infoFromResults(_ results: [[String:AnyObject]]) -> [Student] {
            var studentsInfo = [Student]()
            for result in results {
                studentsInfo.append(Student(dictionary: result))
            }
            return studentsInfo
        }
    }

