//
//  StudentInfo.swift
//  On The Map
//
//  Created by Patrick on 11/3/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//



import Foundation

    // read in dirctionary and store 6 elements
    struct Student {
        var key = String()
        var firstName = String()
        var lastName = String()
        var url = String()
        var lat = Double()
        var lon = Double()
        
        // remove nil NSNULL in return JOSN data
        init(dictionary: [String:AnyObject]) {
            if let key = dictionary["uniqueKey"] as? String, let  firstName = dictionary["firstName"] as? String, let lastName = dictionary["lastName"] as? String, let url = dictionary["mediaURL"] as? String, let lat = dictionary["latitude"] as? Double, let lon = dictionary["longitude"] as? Double {
                self.key = key
                self.firstName = firstName
                self.lastName = lastName
                self.url = url
                self.lat = lat
                self.lon = lon
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

// test
class StudentClass {
    var key = String()
    var firstName = String()
    var lastName = String()
    var url = String()
    var lat = Double()
    var lon = Double()

    // remove nil in return data and store it to propert
    init(dictionary: [String:AnyObject]) {
        if let key = dictionary["uniqueKey"] as? String, let  firstName = dictionary["firstName"] as? String, let lastName = dictionary["lastName"] as? String, let url = dictionary["mediaURL"] as? String, let lat = dictionary["latitude"] as? Double, let lon = dictionary["longitude"] as? Double {
            self.key = key
            self.firstName = firstName
            self.lastName = lastName
            self.url = url
            self.lat = lat
            self.lon = lon
        }
    }
    
    static func infoFromResults(_ results: [[String:AnyObject]]) -> [StudentClass] {
        var studentsInfo = [StudentClass]()
//        let test = studentsInfo[0]
//        test.firstName = "patrick"
//        print("%%%%%%%%%  test",test.firstName)
        
        for result in results {
            studentsInfo.append(StudentClass(dictionary: result))
        }
        return studentsInfo
    }
}

// convert an array of dictionary to array of StudentClass
class convert {
    static func infoFromResults(input results: [[String:AnyObject]]) -> [StudentClass] {
        var studentsInfo = [StudentClass]()
        //        let test = studentsInfo[0]
        //        test.firstName = "patrick"
        //        print("%%%%%%%%%  test",test.firstName)
        
        for result in results {
            studentsInfo.append(StudentClass(dictionary: result))
        }
        return studentsInfo
    }
}
