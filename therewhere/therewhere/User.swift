//
//  User.swift
//  therewhere
//
//  Created by Marcelo Lebre on 07/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation
class User: NSObject {
    
    struct Response {
        static var requestOperation = RKObjectRequestOperation()
        static var rkMappingResult = RKMappingResult()
        static var statusCodes = RKStatusCodeIndexSetForClass(UInt(RKStatusCodeClassSuccessful));
    }
    
    func createUser(firstName:String, lastName:String, phoneNumber: String, email: String) {

        var createUserResponseMapping = RKObjectMapping(forClass: CreateUserResponse.self);

        createUserResponseMapping.addAttributeMappingsFromDictionary(["id":"userID",
            "first_name":"firstName",
            "last_name":"lastName",
            "email":"email",
            "created_at":"createdAt",
            "updated_at":"updatedAt",
            "phone_nr":"phoneNumber"
            ]);

        
        var createUserResponseDecriptor = RKResponseDescriptor(
            mapping: createUserResponseMapping,
            method: RKRequestMethod.Any,
            pathPattern: nil,
            keyPath: nil,
            statusCodes: nil);
        
        
        var createUserRequestMapping = RKObjectMapping.requestMapping()
        
        createUserRequestMapping.addAttributeMappingsFromDictionary([
            "firstName":"first_name",
            "lastName":"last_name",
            "email":"email",
            "phoneNumber":"phone_nr"
            ]);
        

        var createUserRequestDecriptor = RKRequestDescriptor(
            mapping: createUserRequestMapping,
            objectClass: CreateUserRequest.self,
            rootKeyPath: nil,
            method:RKRequestMethod.Any)

        
        
        var url = NSURL(string: TWAPIManager.twAPI_ip())
        var rkmanager = RKObjectManager(baseURL:url)

        rkmanager.addRequestDescriptor(createUserRequestDecriptor)
        rkmanager.addResponseDescriptor(createUserResponseDecriptor)
        
        var createUserRequest = CreateUserRequest()
        createUserRequest.email = email
        createUserRequest.firstName = firstName
        createUserRequest.lastName = lastName
        createUserRequest.phoneNumber = phoneNumber
        
        var createUserResponse = CreateUserResponse()
        
        var requestUrl =  TWAPIManager.twAPI_ip()+"/api/v1/users"
        
        var rkMappingResult = RKMappingResult()
        var requestOperation = RKObjectRequestOperation()
        var response = CreateUserResponse()
        
        rkmanager.postObject(createUserRequest,
            path: requestUrl,
            parameters:nil,
            success:{ requestOperation, rkMappingResult in
                response = rkMappingResult.firstObject() as CreateUserResponse
                var id = response.userID;
            },
            failure:{ operation, error in
                NSLog("Broomshakalaka all over again..")
            }
        )
        
        rkmanager.removeRequestDescriptor(createUserRequestDecriptor)
        rkmanager.removeResponseDescriptor(createUserResponseDecriptor)

    }
    
    func addFriends(phoneNumberArray: [String]) {
        var addFriendsResponseMapping = RKObjectMapping(forClass: AddFriendsResponse.self);
        
        addFriendsResponseMapping.addAttributeMappingsFromDictionary(["total_friends_count":"totalFriendsCount"]);
        
        
        var addFriendsResponseDecriptor = RKResponseDescriptor(
            mapping: addFriendsResponseMapping,
            method: RKRequestMethod.Any,
            pathPattern: nil,
            keyPath: nil,
            statusCodes: nil);
        
        
        var addFriendsRequestMapping = RKObjectMapping.requestMapping()
        
        addFriendsRequestMapping.addAttributeMappingsFromDictionary(["phoneNumberArray":"phone_nrs"]);
        
        var addFriendsRequestDecriptor = RKRequestDescriptor(
            mapping: addFriendsRequestMapping,
            objectClass: AddFriendsRequest.self,
            rootKeyPath: nil,
            method:RKRequestMethod.Any)
        
        var url = NSURL(string: TWAPIManager.twAPI_ip())
        var rkmanager = RKObjectManager(baseURL:url)
        
        rkmanager.addRequestDescriptor(addFriendsRequestDecriptor)
        rkmanager.addResponseDescriptor(addFriendsResponseDecriptor)
        
        var addFriendsRequest = AddFriendsRequest()
        addFriendsRequest.phoneNumberArray = phoneNumberArray
        
        var addFriendsResponse = AddFriendsResponse()
        
        var requestUrl =  TWAPIManager.twAPI_ip()+"/api/v1/users/1/friends"
        
        var rkMappingResult = RKMappingResult()
        var requestOperation = RKObjectRequestOperation()
        var response = AddFriendsResponse()
        
        rkmanager.postObject(addFriendsRequest,
            path: requestUrl,
            parameters:nil,
            success:{ requestOperation, rkMappingResult in
                response = rkMappingResult.firstObject() as AddFriendsResponse
            },
            failure:{ operation, error in
                NSLog("Broomshakalaka all over again..")
            }
        )
        
        rkmanager.removeRequestDescriptor(addFriendsRequestDecriptor)
        rkmanager.removeResponseDescriptor(addFriendsResponseDecriptor)

    }
    
    func getFriends() -> [String] {
        var phoneNumberArray: [String] = ["1", "2"]
        
        var getFriendsResponseMapping = RKObjectMapping(forClass: Friend.self);
        
        getFriendsResponseMapping.addAttributeMappingsFromDictionary(["id":"userID",
            "first_name":"firstName",
            "last_name":"lastName",
            "email":"email",
            "phone_nr":"phoneNumber"
            ]);
        
        
        var getFriendsResponseDecriptor = RKResponseDescriptor(
            mapping: getFriendsResponseMapping,
            method: RKRequestMethod.Any,
            pathPattern: nil,
            keyPath: nil,
            statusCodes: nil);
        
        
        var url = NSURL(string: TWAPIManager.twAPI_ip())
        var rkmanager = RKObjectManager(baseURL:url)
        
        rkmanager.addResponseDescriptor(getFriendsResponseDecriptor)
        
        var requestUrl =  TWAPIManager.twAPI_ip()+"/api/v1/users/1/friends"
        
        var urlPath = NSURL(string: requestUrl)
        var urlRequest = NSURLRequest(URL: urlPath!)
        
        var operation = RKObjectRequestOperation(request:urlRequest, responseDescriptors: [getFriendsResponseDecriptor])
        
        var rkMappingResult = RKMappingResult()
        
        var response = Friend()

        
        operation.setCompletionBlockWithSuccess({operation, rkMappingResult in
                for object in rkMappingResult.array(){
                    response = object as Friend
                    println(response.userID)

                }
            }, failure: { operation, error in
                NSLog("Broomshakalaka all over again..")
            })


        operation.start()
        
        return phoneNumberArray
    }
}