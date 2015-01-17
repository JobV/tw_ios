//
//  GetUserInfoResponse.swift
//  therewhere
//
//  Created by Marcelo Lebre on 17/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation

class GetUserInfoResponse: NSObject {
    var userID = Int();
    var firstName = String();
    var lastName = String();
    var email = String();
    var createdAt = String();
    var updatedAt = String();
    var phoneNumber = String();
}