//
//  Meetups.swift
//  therewhere
//
//  Created by Marcelo Lebre on 25/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation
class Meetups: NSObject {
    
//    struct Response {
//        static var requestOperation = RKObjectRequestOperation()
//        static var rkMappingResult = RKMappingResult()
//        static var statusCodes = RKStatusCodeIndexSetForClass(UInt(RKStatusCodeClassSuccessful));
//    }
//    
//    func getMeetupRequests() -> (Int) {
//        
//        var id = UserProfile.sharedInstance.getUserID()
//                
//        var getMeetupsResponseMapping = RKObjectMapping(forClass: Meetup.self);
//        
//        getMeetupsResponseMapping.addAttributeMappingsFromDictionary(["friend_id":"friendID",
//            "meetup_id":"meetupID",
//            "created_date":"createdDate"
//            ]);
//        
//        
//        var getMeetupsResponseDecriptor = RKResponseDescriptor(
//            mapping: getMeetupsResponseMapping,
//            method: RKRequestMethod.Any,
//            pathPattern: nil,
//            keyPath: nil,
//            statusCodes: nil);
//        
//        
//        var url = NSURL(string: TWAPIManager.twAPI_ip())
//        var rkmanager = RKObjectManager(baseURL:url)
//        
//        rkmanager.addResponseDescriptor(getMeetupsResponseDecriptor)
//        
//        var requestUrl =  TWAPIManager.twAPI_ip()+"/api/v1/users/"+id+"/meetups"
//        
//        var urlPath = NSURL(string: requestUrl)
//        var urlRequest = NSURLRequest(URL: urlPath!)
//        
//        var operation = RKObjectRequestOperation(request:urlRequest, responseDescriptors: [getMeetupsResponseDecriptor])
//        
//        var rkMappingResult = RKMappingResult()
//        
//        var response = Meetup()
//        
//        rkmanager.getObjectsAtPath(
//            requestUrl,
//            parameters: nil,
//            success:{ operation, rkMappingResult in
//                println(rkMappingResult.array().count)
//            },
//            failure:{ operation, error in
//                NSLog("Broomshakalaka all over again..")
//        })
//        
//        return 1
//    }
}