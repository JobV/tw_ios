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
                    var json_response = JSON(json!)
                    
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
                    var json_response = JSON(json!)
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
                    var json = JSON(json!)
                    var friends = Friends()
                    
                    for (index: String, subJson: JSON) in json {
                        var fullName = ""
                        var friendID = 0
                        var statusWithFriend = ""
                        var friendPhoneNr = ""
                        
                        if var firstName = subJson["first_name"].string{
                            fullName = firstName
                        }
                        
                        if var lastName = subJson["last_name"].string{
                            fullName += " " + lastName
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

                        let friendTuple:(String, Int, String, String) = (fullName, friendID, statusWithFriend, friendPhoneNr)
                        
                        friends.phoneNumberArray.append(friendTuple)
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
    
}