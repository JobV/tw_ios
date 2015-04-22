//
//  Friends.swift
//  therewhere
//
//  Created by Marcelo Lebre on 11/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit
import UIKit

class Friends: NSObject {
    
    class Coordinates {
        var latitude:CLLocationDegrees = 0.0
        var longitude:CLLocationDegrees = 0.0
    }
    
    // GET Method - Gets friend location
    // Whenever friend location is received, a notification is sent, usually to the map view
    func getLocation(friendID : String){
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+friendID+"/location"
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
                    var json = SwiftyJSON.JSON(json!)
                    
                    if json["x"]&&json["y"] {
                        var latitude = 0.0
                        var longitude = 0.0
                        
                        if var latitudeFromJson = json["x"].double{
                            latitude = latitudeFromJson
                        }
                        
                        if var longitudeFromJson = json["y"].double{
                            longitude = longitudeFromJson
                        }
                        
                        var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        var friendCoordinates = Coordinates()
                        
                        friendCoordinates.latitude = coordinate.latitude
                        friendCoordinates.longitude = coordinate.longitude
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("friendLocationUpdate", object: nil, userInfo:["location":friendCoordinates])
                    }else{
                        println("no location available! sorry mate ")
                    }
                }
        }
        
    }
    
}