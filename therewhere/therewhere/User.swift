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
        
    func getUserInfo ()-> (Bool){
        var result = true
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+UserProfile.sharedInstance.userID
        
        Alamofire.request(.GET, url)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                    result = false
                }
                else {
                    NSLog("REST: getUserInfo")
                    var json = JSON(json!)
                    var userProfile = UserProfile.sharedInstance
                    
                    userProfile.userID = json["id"].string!
                    userProfile.firstName = json["first_name"].string!
                    userProfile.lastName = json["last_name"].string!
                    userProfile.email = json["email"].string!
                    userProfile.phoneNumber = json["phone_nr"].string!
                }
        }
        return result
    }
    
    func getFriends()-> (Bool){
        var result = true
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+UserProfile.sharedInstance.userID+"/friends"
        
        Alamofire.request(.GET, url)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                    result=false
                }
                else {
                    NSLog("REST: getFriends")
                    var json = JSON(json!)
                    var friends = Friends()
                    
                    for (index: String, subJson: JSON) in json {
                        var fullName = subJson["first_name"].string! + " " + subJson["last_name"].string!
                        let friendTuple:(String, Int) = (fullName, subJson["id"].int!)
                        friends.phoneNumberArray.append(friendTuple)
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("getFriendsNotification", object: friends)
                }
        }
        return result
    }
    
    func addFriends(phoneNumberArray: [String]) -> Bool{
        var result = true
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+user.userID+"/friends"
        let parameters = [
            "phone_nrs": phoneNumberArray
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .response { (request, response, _, error) in
                if(error != nil){
                    result = false
                }
        }
        return result
    }
    
    func createUser(firstName:String, lastName:String, phoneNumber: String, email: String) -> Bool {
        var result = true
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"
        let parameters = [
            "first_name":firstName,
            "last_name":lastName,
            "phone_nr":phoneNumber,
            "email":email
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .response { (request, response, _, error) in
                if(error != nil){
                    result = false
                }
        }
        
        return result
    }
    
    func setLocation (coordinate: CLLocationCoordinate2D) -> (String) {
        var result = " "
        
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+user.userID+"/location"
        let parameters = [
            "x": coordinate.longitude,
            "y": coordinate.latitude,
            "z": 0,
            "m": 0
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                    result = "couldn't set location"
                    
                }
                else {
                    NSLog("REST: setLocation")
                    var json = JSON(json!)
                    var updatedDate = json["updated_at"].string!
                    result = updatedDate
                    println("location updated at: \(result)")
                }
        }

        return result
    }
    

}