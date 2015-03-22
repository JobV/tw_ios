//
//  UserProfile.swift
//  therewhere
//
//  Created by Marcelo Lebre on 17/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

@objc class FriendList: NSObject {
    class var sharedInstance: FriendList {
        struct Static {
            static var instance: FriendList?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = FriendList()
        }
        
        return Static.instance!
    }
    var friendList = NSMutableSet();
    
}
