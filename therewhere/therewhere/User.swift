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
        static var operation = RKObjectRequestOperation()
        static var mappingResult = RKMappingResult()
        static var statusCodes = RKStatusCodeIndexSetForClass(UInt(RKStatusCodeClassSuccessful));
    }
    
    func createUser(firstName:String, lastName:String, phoneNumber: String, email: String) -> String {
        var date = ""
        
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
        

        
        rkmanager.postObject(createUserRequest,
            path: requestUrl,
            parameters:nil,
            success:{ RKObjectRequestOperation, thismappingResult in
                Response.mappingResult = thismappingResult
                NSLog(String(Response.mappingResult.count() ))
            },
            failure:{ operation, error in
                NSLog("What do you mean by 'there is no coffee?'")
            }
            
        )
        
        
        rkmanager.removeRequestDescriptor(createUserRequestDecriptor)
        rkmanager.removeResponseDescriptor(createUserResponseDecriptor)

        
        return "a"
    }
}