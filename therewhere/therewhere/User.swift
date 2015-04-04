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
                    user.access_token = json_response["auth_token"].string!
                    
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
                    
                    userProfile.userID = json_response["id"].string!
                    userProfile.firstName = json_response["first_name"].string!
                    userProfile.lastName = json_response["last_name"].string!
                    userProfile.email = json_response["email"].string!
                    userProfile.phoneNumber = json_response["phone_nr"].string!
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
                        
                        var fullName = subJson["first_name"].string! + " " + subJson["last_name"].string!
                        let friendTuple:(String, Int, String, String) = (fullName, subJson["id"].int!, subJson["status_with_friend"].string!, subJson["phone_nr"].string! )
                        
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
                    var json = JSON(json!)
                    var updatedDate = json["updated_at"].string!
                    
                    result = updatedDate
                }
        }
        
        return result
    }
    
}