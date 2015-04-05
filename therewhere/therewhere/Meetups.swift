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
        let url = APIConnectionManager.serverAddress+"/api/v1/users/meetups"
        var user = UserProfile.sharedInstance
        let parameters = [
            "token": user.access_token
        ]
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                }
                else {
                    var json = JSON(json!)
                    
                    if var received = json["received"].int{
                        if received == 0 {
                            println("no pending received meetups!")
                        }else{
                            var count = received
                            println("received \(count) meetup requests!")
                        }
                    }
                    
                    if var sent = json["sent"].int{
                        if sent == 0 {
                            println("no pending sent meetups!")
                        }else{
                            var count = sent
                            println("sent \(count) meetup requests!")
                        }
                    }
                }
        }
    }
    
    // POST Method - Creates meetup request with friend
    func requestMeetup(friendID: String)->Bool{
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/meetups"
        var success:Bool = false
        let parameters = [
            "friend_id": friendID,
            "token": user.access_token
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, json, error) in
                if(error != nil){
                    NSLog("Error: \(error)")
                }else{
                    var json = JSON(json!)
                    
                    if var message = json["success"].string{
                        println("created meetup")
                    }
                }
        }
        return success
    }
    
    // POST Method - Accepts a meetup request
    func acceptMeetup(friendID: String){
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/meetups/accept"
        let parameters = [
            "friend_id": friendID,
            "token": user.access_token
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, json, error) in
                if(error != nil){
                    NSLog("Error: \(error)")
                }else{
                    var json = JSON(json!)
                    
                    if var message = json["success"].string{
                        println("accepted meetup")
                    }
                }
        }
    }
    
    // POST Method - Decline meetup request
    func declineToMeetup(friendID: String){
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/meetups/decline"
        let parameters = [
            "friend_id": friendID,
            "token": user.access_token
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, json, error) in
                if(error != nil){
                    NSLog("Error: \(error)")
                }else{
                    var json = JSON(json!)
                    
                    if var message = json["success"].string{
                        println("meetup declined")
                    }
                }
        }
    }
    
    // POST Method - Terminate meetup with a friend
    func terminateMeetup(friendID: String){
        var user = UserProfile.sharedInstance
        let url = APIConnectionManager.serverAddress+"/api/v1/users/meetups/terminate"
        let parameters = [
            "friend_id": friendID,
            "token": user.access_token
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON { (request, response, json, error) in
                if(error != nil){
                    NSLog("Error: \(error)")
                }else{
                    var json = JSON(json!)
                    if var message = json["success"].string{
                        println("terminated friend meetup")
                    }
                }
        }
    }
    
    
}