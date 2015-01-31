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
    
//    struct Response {
//        static var requestOperation = RKObjectRequestOperation()
//        static var rkMappingResult = RKMappingResult()
//        static var statusCodes = RKStatusCodeIndexSetForClass(UInt(RKStatusCodeClassSuccessful));
//    }
//    
//    
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
//    func addFriends(phoneNumberArray: [String]) {
//        var id = UserProfile.sharedInstance.getUserID()
//        
//        var addFriendsResponseMapping = RKObjectMapping(forClass: AddFriendsResponse.self);
//        
//        addFriendsResponseMapping.addAttributeMappingsFromDictionary(["total_friends_count":"totalFriendsCount"]);
//        
//        
//        var addFriendsResponseDecriptor = RKResponseDescriptor(
//            mapping: addFriendsResponseMapping,
//            method: RKRequestMethod.Any,
//            pathPattern: nil,
//            keyPath: nil,
//            statusCodes: nil);
//        
//        
//        var addFriendsRequestMapping = RKObjectMapping.requestMapping()
//        
//        addFriendsRequestMapping.addAttributeMappingsFromDictionary(["phoneNumberArray":"phone_nrs"]);
//        
//        var addFriendsRequestDecriptor = RKRequestDescriptor(
//            mapping: addFriendsRequestMapping,
//            objectClass: AddFriendsRequest.self,
//            rootKeyPath: nil,
//            method:RKRequestMethod.Any)
//        
//        var url = NSURL(string: TWAPIManager.twAPI_ip())
//        var rkmanager = RKObjectManager(baseURL:url)
//        
//        rkmanager.addRequestDescriptor(addFriendsRequestDecriptor)
//        rkmanager.addResponseDescriptor(addFriendsResponseDecriptor)
//        
//        var addFriendsRequest = AddFriendsRequest()
//        addFriendsRequest.phoneNumberArray = phoneNumberArray
//        
//        var addFriendsResponse = AddFriendsResponse()
//
//        var requestUrl =  TWAPIManager.twAPI_ip()+"/api/v1/users/"+id+"/friends"
//        
//        var rkMappingResult = RKMappingResult()
//        var requestOperation = RKObjectRequestOperation()
//        var response = AddFriendsResponse()
//        
//        rkmanager.postObject(addFriendsRequest,
//            path: requestUrl,
//            parameters:nil,
//            success:{ requestOperation, rkMappingResult in
//                response = rkMappingResult.firstObject() as AddFriendsResponse
//            },
//            failure:{ operation, error in
//                NSLog("Broomshakalaka all over again..")
//            }
//        )
//        
//        rkmanager.removeRequestDescriptor(addFriendsRequestDecriptor)
//        rkmanager.removeResponseDescriptor(addFriendsResponseDecriptor)
//
//    }
//    
//    func getFriends() -> [(String,Int)] {
//
//        var id = UserProfile.sharedInstance.getUserID()
//        
//        var phoneNumberArray : [(String, Int)] = []
//        
//        var getFriendsResponseMapping = RKObjectMapping(forClass: Friend.self);
//        
//        getFriendsResponseMapping.addAttributeMappingsFromDictionary(["id":"userID",
//            "first_name":"firstName",
//            "last_name":"lastName",
//            "email":"email",
//            "phone_nr":"phoneNumber"
//            ]);
//        
//        
//        var getFriendsResponseDecriptor = RKResponseDescriptor(
//            mapping: getFriendsResponseMapping,
//            method: RKRequestMethod.Any,
//            pathPattern: nil,
//            keyPath: nil,
//            statusCodes: nil);
//        
//        
//        var url = NSURL(string: TWAPIManager.twAPI_ip())
//        var rkmanager = RKObjectManager(baseURL:url)
//        
//        rkmanager.addResponseDescriptor(getFriendsResponseDecriptor)
//        
//        var requestUrl =  TWAPIManager.twAPI_ip()+"/api/v1/users/"+id+"/friends"
//        
//        var urlPath = NSURL(string: requestUrl)
//        var urlRequest = NSURLRequest(URL: urlPath!)
//        
//        var operation = RKObjectRequestOperation(request:urlRequest, responseDescriptors: [getFriendsResponseDecriptor])
//        
//        var rkMappingResult = RKMappingResult()
//        
//        var response = Friend()
//
//        rkmanager.getObjectsAtPath(
//            requestUrl,
//            parameters: nil,
//            success:{ operation, rkMappingResult in
//                var friends = Friends()
//
//                for object in rkMappingResult.array(){
//                    response = object as Friend
//                    var fullName = response.firstName+" "+response.lastName
//                    var friendID:String = toString(response.userID)
//                    let friendTuple:(String, Int) = (fullName, response.userID)
//                    friends.phoneNumberArray.append(friendTuple)
//                    
//                    NSNotificationCenter.defaultCenter().postNotificationName("getFriendsNotification", object: friends)
//                }
//            },
//            failure:{ operation, error in
//                NSLog("Broomshakalaka all over again..")
//            })
//        
//        return phoneNumberArray
//    }
//    
//    func getUserInfo(){
//        var id = UserProfile.sharedInstance.getUserID()
//        
//        var getUserInfoResponseMapping = RKObjectMapping(forClass: UserObject.self);
//        
//        getUserInfoResponseMapping.addAttributeMappingsFromDictionary(["id":"userID",
//            "first_name":"firstName",
//            "last_name":"lastName",
//            "email":"email",
//            "phone_nr":"phoneNumber"
//            ]);
//        
//        
//        var getUserInfoResponseDecriptor = RKResponseDescriptor(
//            mapping: getUserInfoResponseMapping,
//            method: RKRequestMethod.Any,
//            pathPattern: nil,
//            keyPath: nil,
//            statusCodes: nil);
//        
//        
//        var url = NSURL(string: TWAPIManager.twAPI_ip())
//        var rkmanager = RKObjectManager(baseURL:url)
//        
//        rkmanager.addResponseDescriptor(getUserInfoResponseDecriptor)
//        
//        var requestUrl =  TWAPIManager.twAPI_ip()+"/api/v1/users/"+id
//        
//        var urlPath = NSURL(string: requestUrl)
//        var urlRequest = NSURLRequest(URL: urlPath!)
//        
//        var operation = RKObjectRequestOperation(request:urlRequest, responseDescriptors: [getUserInfoResponseDecriptor])
//        
//        var rkMappingResult = RKMappingResult()
//        
//        var response = UserObject()
//        var userProfile = UserProfile.sharedInstance
//        
//        rkmanager.getObjectsAtPath(
//            requestUrl,
//            parameters: nil,
//            success:{ operation, rkMappingResult in
//                response = rkMappingResult.firstObject() as UserObject
//                userProfile.userID = response.userID
//                userProfile.firstName = response.firstName + response.lastName
//                userProfile.email = response.email
//            },
//            failure:{ operation, error in
//                NSLog("Broomshakalaka all over again..")
//        })
//    
//    }
    
    func getUserInfo ()-> (String){
        
        Alamofire.request(.GET, TWAPIManager.twAPI_ip()+"/api/v1/users/1")
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("REST: getUserInfo")
                    var json = JSON(json!)
                    
                    var userProfile = UserProfile.sharedInstance
                    userProfile.userID = json["id"].int!
                    userProfile.firstName = json["first_name"].string!
                    userProfile.lastName = json["last_name"].string!
                    userProfile.email = json["email"].string!
                    userProfile.phoneNumber = json["phone_nr"].string!
                    
                    
                }
        }
        return "a"
    }

}