//
//  UserProfile.swift
//  therewhere
//
//  Created by Marcelo Lebre on 17/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

@objc class UserProfile: NSObject {
    // singleton instance - app can only have one UserProfile
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
    
    func decreaseOnGoingMeetups(){
        if(onGoingMeetups > 0){
            onGoingMeetups -= 1
        }
        else{
            onGoingMeetups = 0
        }
    }
    
    func incrementOnGoingMeetups(){
        onGoingMeetups += 1
    }
    
    // user locally accessible attributes
    var userID = String();
    var firstName = String();
    var lastName = String();
    var email = String();
    var phoneNumber = String();
    var access_token = String();
    var deviceToken = String();
    var onGoingMeetups = 0;
    var profileImage = UIImage();
    var providerID = String();
}
