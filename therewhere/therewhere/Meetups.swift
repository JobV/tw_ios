//
//  Meetups.swift
//  therewhere
//
//  Created by Marcelo Lebre on 25/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Meetups: NSObject {
    
    // GET Method - Gets pending meetup requests
    func getPendingMeetups(){
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+UserProfile.sharedInstance.userID+"/meetups"
        
        Alamofire.request(.GET, url)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                }
                else {
                    var json = JSON(json!)
                    
                    if json["received"].count == 0 {
                        println("no pending received meetups!")
                    }else{
                        var count = json["received"].count
                        println("received \(count) meetup requests!")
                    }
                    
                    if json["sent"].count == 0 {
                        println("no pending sent meetups!")
                    }else{
                        var count = json["sent"].count
                        println("sent \(count) meetup requests!")
                    }
                }
        }
    }
    
    // POST Method - Creates meetup request with friend
    func requestMeetup(friendID: String)->Bool{
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+user.userID+"/meetups"
        var success:Bool = false
        let parameters = [
            "friend_id": friendID
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, json, error) in
                if(error != nil){
                    NSLog("Error: \(error)")
                }else{
                    var json = JSON(json!)
                    
                    if json["success"]{
                        success = true
                    }
                }
        }
        return success
    }
    
    // POST Method - Accepts a meetup request
    func acceptMeetup(friendID: String){
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+user.userID+"/meetups/accept"
        let parameters = [
            "friend_id": friendID
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, json, error) in
                if(error != nil){
                    NSLog("Error: \(error)")
                }else{
                    var json = JSON(json!)
                    
                    if json["success"]{
                        println("accepted friend request")
                    }
                }
        }
    }
    
    // POST Method - Decline meetup request
    func declineToMeetup(friendID: String){
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+user.userID+"/meetups/decline"
        let parameters = [
            "friend_id": friendID
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, json, error) in
                if(error != nil){
                    NSLog("Error: \(error)")
                }else{
                    var json = JSON(json!)
                    
                    if json["success"]{
                        println("declined friend request")
                    }
                }
        }
    }
    
    // POST Method - Terminate meetup with a friend
    func terminateMeetup(friendID: String){
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+user.userID+"/meetups/terminate"
        let parameters = [
            "friend_id": friendID
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, json, error) in
                if(error != nil){
                    NSLog("Error: \(error)")
                }else{
                    var json = JSON(json!)
                    
                    if json["success"]{
                        println("terminated friend meetup")
                    }
                }
        }
    }
    
    
}