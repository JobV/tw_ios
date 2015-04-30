//
//  User.swift
//  therewhere
//
//  Created by Marcelo Lebre on 07/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit

@objc class User: NSObject {
    
    func getUserProfilePicture(){
        let urlRequest = callFacebook("me/picture?type=large")
        let cache = Shared.dataCache
        var user = UserProfile.sharedInstance
        
        cache.fetch(key: user.providerID as String)
            .onSuccess { data in
                user.profileImage = UIImage(data: data)!
            }
            .onFailure { _ -> () in
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    var user = UserProfile.sharedInstance
                    cache.set(value: data, key: user.providerID as String)
                    user.profileImage = UIImage(data: data)!
                }
        }
    }
    
    func getFriendProfilePicture(friendID: String) {
        let urlRequest = callFacebook("\(friendID)/picture?type=large")
        let cache = Shared.dataCache
        
        cache.fetch(key: friendID as String)
            .onSuccess { data in
                NSNotificationCenter.defaultCenter().postNotificationName("friendProfileImage", object: data)
            }
            .onFailure { _ -> () in
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                    cache.set(value: data, key: friendID as String)
                    NSNotificationCenter.defaultCenter().postNotificationName("friendProfileImage", object: data)
                }
        }
    }
    
    // Cache in all profile images
    func getProfilePicture(userID: String){
        let urlRequest = callFacebook("\(userID)/picture?type=large")
        let cache = Shared.dataCache
        
        cache.fetch(key: userID as String)
            .onFailure { _ -> () in
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                    cache.set(value: data, key: userID as String)
                }
        }
    }

    func getCoverPicture(){
        let urlRequest = callFacebook("/me/cover")
        let cache = Shared.dataCache
        var user = UserProfile.sharedInstance
        
        cache.fetch(key: user.providerID as String)
            .onSuccess { data in
                user.coverImage = UIImage(data: data)!
            }
            .onFailure { _ -> () in
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    var user = UserProfile.sharedInstance
                    cache.set(value: data, key: user.providerID as String)
                    user.coverImage = UIImage(data: data)!
                }
        }
    }

//    func getCoverPicture(userID: String){
//        let urlRequest = callFacebook("\(userID)/cover?type=large")
//        let cache = Shared.dataCache
//        
//        cache.fetch(key: userID as String)
//            .onFailure { _ -> () in
//                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
//                    cache.set(value: data, key: userID as String)
//                }
//        }
//    }
    
        // POST Method - Log out
        func logout(){
            var user = UserProfile.sharedInstance
            let url = APIConnectionManager.serverAddress+"/api/v1/auth/logout"
            let parameters = [
                "token": user.access_token
            ]
            
            Alamofire.request(.DELETE, url, parameters: parameters, encoding: .JSON)
                .validate(statusCode: 200..<300)
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        NSLog("Error: Logout Error")
                    }
                    else {
                        NSLog("Log Out")
                        var userProfile = UserProfile.sharedInstance
                        
                        userProfile.firstName = ""
                        userProfile.lastName = ""
                        userProfile.email = ""
                        userProfile.access_token = ""
                    }
            }
        }
        
        // POST Method - Authenticate with backend api
        func authenticate(oauth_token: String) -> Bool{
            var result = true
            var user = UserProfile.sharedInstance
            let url = APIConnectionManager.serverAddress+"/api/v1/auth/login"
            let parameters = [
                "login" : user.email,
                "oauth_token": oauth_token,
                "device_token": user.deviceToken
            ]
            
            Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
                .validate(statusCode: 200..<300)
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        NSLog("Error: Authentication Error")
                    }
                    else {
                        var json_response = SwiftyJSON.JSON(json!)
                        
                        if let auth_token = json_response["auth_token"].string{
                            user.access_token = auth_token
                        }
                        
                        if(user.access_token != ""){
                            NSNotificationCenter.defaultCenter().postNotificationName("authenticationNotification", object: nil)
                        }
                    }
            }
            
            return result
        }
        
        // GET Method - Retrieves user info from the backend api
        func getUserInfo(){
            var user = UserProfile.sharedInstance
            let url = APIConnectionManager.serverAddress+"/api/v1/users"
            let parameters = [
                "token": user.access_token
            ]
            
            Alamofire.request(.GET, url, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        NSLog("Error: \(error)")
                    }
                    else {
                        NSLog("getting user info")
                        var json_response = SwiftyJSON.JSON(json!)
                        var userProfile = UserProfile.sharedInstance
                        
                        if var userID = json_response["id"].string{
                            userProfile.userID = userID
                        }
                        
                        if var firstName = json_response["first_name"].string{
                            userProfile.firstName = firstName
                        }
                        
                        if var lastName = json_response["last_name"].string{
                            userProfile.lastName = lastName
                        }
                        
                        if var email = json_response["email"].string{
                            userProfile.email = email
                        }
                        
                        if var phoneNumber = json_response["phone_nr"].string{
                            userProfile.phoneNumber = phoneNumber
                        }
                    }
            }
        }
        
        // GET Method - Retrieve user friends
        // Internal notifiction is fired to notify end of list update
        func getFriends(){
            let url = APIConnectionManager.serverAddress+"/api/v1/users/friends"
            var user = UserProfile.sharedInstance
            let parameters = [
                "token": user.access_token
            ]
            
            Alamofire.request(.GET, url, parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        NSLog("error: getFriends unsuccessful")
                    }
                    else {
                        var json = SwiftyJSON.JSON(json!)
                        var friends : [(FriendProfile)] = []
                        
                        for (index: String, subJson: SwiftyJSON.JSON) in json {
                            var friendProfile = FriendProfile()
                            var fullName = ""
                            var friendID = 0
                            var statusWithFriend = ""
                            var friendPhoneNr = ""
                            var provider = ""
                            var providerID = ""
                            var firstName = ""
                            var lastName = ""
                            
                            if var firstNameFromJson = subJson["first_name"].string{
                                firstName = firstNameFromJson
                            }
                            
                            if var lastNameFromJson = subJson["last_name"].string{
                                lastName = lastNameFromJson
                                fullName = firstName + " " + lastName
                            }
                            
                            if var friendIDFromJson = subJson["id"].int{
                                friendID = friendIDFromJson
                            }
                            if var statusWithFriendFromJson = subJson["status_with_friend"].string{
                                statusWithFriend = statusWithFriendFromJson
                            }
                            
                            if var friendPhoneNrFromJson = subJson["phone_nr"].string{
                                friendPhoneNr = friendPhoneNrFromJson
                            }
                            
                            if var providerFromJson = subJson["provider"].string{
                                provider = providerFromJson
                            }
                            
                            if var providerIDFromJson = subJson["provider_id"].string{
                                providerID = providerIDFromJson
                                self.getProfilePicture(providerID)
                            }
                            
                            friendProfile.firstName = firstName
                            friendProfile.lastName = lastName
                            friendProfile.fullName = fullName
                            friendProfile.friendID = friendID
                            friendProfile.provider = provider
                            friendProfile.providerID = providerID
                            friendProfile.phoneNumber = friendPhoneNr
                            friendProfile.statusWithFriend = statusWithFriend
                            
                            friends.append(friendProfile)
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("getFriendsNotification", object: friends)
                    }
            }
        }
        
        // POST Method - Sends list of user's friends
        func addFriends(phoneNumberArray: [String]) -> Bool{
            var result = true
            var user = UserProfile.sharedInstance
            let url = APIConnectionManager.serverAddress+"/api/v1/users/friends"
            
            
            let parameters = [
                "token": user.access_token,
                "phone_nrs": phoneNumberArray as NSObject
            ]
            
            Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
                .validate(statusCode: 200..<300)
                .response { (request, response, _, error) in
                    if(error != nil){
                        result = false
                    }
            }
            
            return result
        }
        
        // POST Method - Update user location
        func setLocation (coordinate: CLLocationCoordinate2D) -> (String) {
            var result = " "
            var user = UserProfile.sharedInstance
            let url = APIConnectionManager.serverAddress+"/api/v1/users/location"
            let parameters = [
                "x": coordinate.latitude,
                "y": coordinate.longitude,
                "z": 0,
                "m": 0,
                "token": user.access_token as NSObject
            ]
            
            Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
                .validate(statusCode: 200..<300)
                .responseJSON { (req, res, json, error) in
                    if(error != nil) {
                        result = "couldn't set location"
                    }
                    else {
                        
                    }
            }
            
            return result
        }
    
    // Make a call to the Facebook Graph API
    func callFacebook(api_call: String) -> (NSURLRequest) {
        var accessToken = FBSession.activeSession().accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/\(api_call)&return_ssl_resources=1&access_token=\(accessToken)")
        return NSURLRequest(URL: url!)
    }
        
}