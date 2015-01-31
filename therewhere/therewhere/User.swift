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
class User: NSObject {
    
//    func createUser(firstName:String, lastName:String, phoneNumber: String, email: String) {
//
//        var createUserResponseMapping = RKObjectMapping(forClass: CreateUserResponse.self);
//
//        createUserResponseMapping.addAttributeMappingsFromDictionary(["id":"userID",
//            "first_name":"firstName",
//            "last_name":"lastName",
//            "email":"email",
//            "created_at":"createdAt",
//            "updated_at":"updatedAt",
//            "phone_nr":"phoneNumber"
//            ]);
//
//        
//        var createUserResponseDecriptor = RKResponseDescriptor(
//            mapping: createUserResponseMapping,
//            method: RKRequestMethod.Any,
//            pathPattern: nil,
//            keyPath: nil,
//            statusCodes: nil);
//        
//        
//        var createUserRequestMapping = RKObjectMapping.requestMapping()
//        
//        createUserRequestMapping.addAttributeMappingsFromDictionary([
//            "firstName":"first_name",
//            "lastName":"last_name",
//            "email":"email",
//            "phoneNumber":"phone_nr"
//            ]);
//        
//
//        var createUserRequestDecriptor = RKRequestDescriptor(
//            mapping: createUserRequestMapping,
//            objectClass: CreateUserRequest.self,
//            rootKeyPath: nil,
//            method:RKRequestMethod.Any)
//
//        
//        
//        var url = NSURL(string: TWAPIManager.twAPI_ip())
//        var rkmanager = RKObjectManager(baseURL:url)
//
//        rkmanager.addRequestDescriptor(createUserRequestDecriptor)
//        rkmanager.addResponseDescriptor(createUserResponseDecriptor)
//        
//        var createUserRequest = CreateUserRequest()
//        createUserRequest.email = email
//        createUserRequest.firstName = firstName
//        createUserRequest.lastName = lastName
//        createUserRequest.phoneNumber = phoneNumber
//        
//        var createUserResponse = CreateUserResponse()
//        
//        var requestUrl =  TWAPIManager.twAPI_ip()+"/api/v1/users"
//        
//        var rkMappingResult = RKMappingResult()
//        var requestOperation = RKObjectRequestOperation()
//        var response = CreateUserResponse()
//        
//        rkmanager.postObject(createUserRequest,
//            path: requestUrl,
//            parameters:nil,
//            success:{ requestOperation, rkMappingResult in
//                response = rkMappingResult.firstObject() as CreateUserResponse
//                var id = response.userID;
//            },
//            failure:{ operation, error in
//                NSLog("Broomshakalaka all over again..")
//            }
//        )
//        
//        rkmanager.removeRequestDescriptor(createUserRequestDecriptor)
//        rkmanager.removeResponseDescriptor(createUserResponseDecriptor)
//
//    }
//
    
    func getUserInfo ()-> (Bool){
        var result = true
        let url = TWAPIManager.twAPI_ip()+"/api/v1/users/"+UserProfile.sharedInstance.userID
        
        Alamofire.request(.GET, TWAPIManager.twAPI_ip()+"/api/v1/users/1")
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
        let url = TWAPIManager.twAPI_ip()+"/api/v1/users/"+UserProfile.sharedInstance.userID+"/friends"
        
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
        let parameters = [
            "phone_nrs": phoneNumberArray
        ]
        
        let url = TWAPIManager.twAPI_ip()+"/api/v1/users/"+user.userID+"/friends"
        
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
        let url = TWAPIManager.twAPI_ip()+"/api/v1/users/"
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

}