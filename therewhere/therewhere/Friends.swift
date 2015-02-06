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

class Friends: NSObject {
    var phoneNumberArray : [(String, Int)] = []
    
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
                        var latitude :Double? = json["y"].double!
                        var longitude :Double? = json["x"].double!
                        var coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                    }else{
                        println("no location available! sorry mate ")
                    }

                }
    }

    }
    
}