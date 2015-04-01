//
//  UserProfile.swift
//  therewhere
//
//  Created by Marcelo Lebre on 17/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

@objc class FacebookHandler: NSObject {
    
    // GET Method to retrieve friends using the app
    // Recursive function, will process each answer and fetch next page with same function
    // Example:
    //    var handler = FacebookHandler()
    //    handler.getFriends("/me/friends")
    
    func getFriends (path: String) {
        FBRequestConnection.startWithGraphPath(path, completionHandler: { (connection:FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if ((error) == nil) {
                var resultdict = result as NSDictionary
                var data : NSArray = resultdict.objectForKey("data") as NSArray
                var paging : NSDictionary = resultdict.objectForKey("paging") as NSDictionary
                var nextURL = paging.objectForKey("next") as String!
                
                if(data.count > 0){
                    var friendlist = FriendList.sharedInstance
                    
                    friendlist.friendList.addObjectsFromArray(data)
                    
                    if(nextURL != nil ){
                        var nextPathSize = distance(nextURL.startIndex, nextURL.endIndex)
                        var nextURLPath = nextURL[advance(nextURL.startIndex, 31)...advance(nextURL.startIndex, nextPathSize-1)]
                        self.getFriends(nextURLPath)
                    }
                }
            } else {
                println("error obtaining data")
            }
        })
    }
}
