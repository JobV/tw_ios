//
//  User.swift
//  therewhere
//
//  Created by Marcelo Lebre on 07/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation

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
    
    
    var createUserResponseDecriptor = RKResponseDescriptor(mapping: createUserResponseMapping,method: RKRequestMethod.Any,pathPattern: nil,keyPath: nil,statusCodes: nil);
    
    var createUserRequestMapping = RKObjectMapping(forClass: CreateUserResponse.self);
    
    createUserRequestMapping.addAttributeMappingsFromDictionary(["id":"userID",
        "first_name":"firstName",
        "last_name":"lastName",
        "email":"email",
        "created_at":"createdAt",
        "updated_at":"updatedAt",
        "phone_nr":"phoneNumber"
        ]);
    
    
    var createUserRequestDecriptor = RKRequestDescriptor(mapping: createUserRequestMapping,method: RKRequestMethod.POST,rootKeyPath: nil, objectClass: CreateUserRequest.self)



    
    return date
}