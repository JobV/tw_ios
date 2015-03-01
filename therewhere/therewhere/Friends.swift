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
    var phoneNumberArray : [(String, Int, String)] = []
    class Coordinates {
        var latitude:CLLocationDegrees = 0.0
        var longitude:CLLocationDegrees = 0.0
    }
    func getLocation(friendID : String){
        let url = APIConnectionManager.serverAddress+"/api/v1/users/"+friendID+"/location"

        Alamofire.request(.GET, url)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("REST: getlocation for id: \(friendID)")
                    var json = JSON(json!)

                    if json["x"]&&json["y"] {
                        var latitude :Double? = json["x"].double!
                        var longitude :Double? = json["y"].double!
                        var coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
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