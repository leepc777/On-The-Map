//
//  MapClientData.swift
//  On The Map
//
//  Created by Patrick on 11/14/17.
//  Copyright © 2017 CodeMobiles. All rights reserved.
//

import Foundation

// MARK: - MapClientData: NSObject , a Singleton
/*
MapClientData and MapClient are both Singleton
MapClient stores global API methods
MapClientData stores global Data including student locations and personal info for the login user.
*/


class MapClientData : NSObject {

    // students info (100 students)
    var studentLocations : [Student]!
    var studentlocationsClass : [StudentClass]!
    // filtered data for the table view after searching
    var filteredDataNew:[Student]!
    
    
    // user info ( one person )
    var userInfo = Personal()

    
    // MARK: Shared Instance
    class func sharedInstance() -> MapClientData {
        struct Singleton {
            static var sharedInstance = MapClientData()
        }
        return Singleton.sharedInstance
    }

}

