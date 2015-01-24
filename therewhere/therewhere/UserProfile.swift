//
//  UserProfile.swift
//  therewhere
//
//  Created by Marcelo Lebre on 17/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

@objc class UserProfile: NSObject {
    class var sharedInstance: UserProfile {
        struct Static {
            static var instance: UserProfile?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = UserProfile()
        }
        
        return Static.instance!
    }
    
    func getUserID() ->(String){
        return (userID as NSNumber).stringValue;
    }
    
    var userID = Int();
    var firstName = String();
    var lastName = String();
    var email = String();
    var phoneNumber = String();
    
}
