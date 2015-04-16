//
//  FriendProfile.swift
//  therewhere
//
//  Created by Marcelo Lebre on 07/03/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import UIKit

class FriendProfile: NSObject {
    // Friend Class representation
    
    var friendID = Int()
    var firstName = String()
    var lastName = String()
    var email = String()
    var phoneNumber = String()
    var provider = String()
    var providerID = String()
    var fullName = String()
    var statusWithFriend = String()
    var profileImage = UIImage()
}
