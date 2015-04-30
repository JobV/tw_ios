//
//  MixpanelHandler.swift
//  therewhere
//
//  Created by Marcelo Lebre on 03/01/15.
//  Copyright (c) 2015 therewhereinc. All rights reserved.
//

import Foundation
import Mixpanel

struct MixpanelHandler{
    static let mixpanelToken = "6ae05520085a72b10108fbae93cad415"
    static let mixpanel = Mixpanel.sharedInstanceWithToken(mixpanelToken)
    
    // App actions
    
    static func applicationWasClosed() {
        mixpanel.track("app", properties:  ["callback":"closed"])
    }
    
    static func applicationWasOpened() {
        mixpanel.track("app", properties:  ["callback":"opened"])
    }
    
    static func applicationEnteredBackground() {
        mixpanel.track("app", properties:  ["callback":"background"])
    }
    
    static func applicationBecameActive() {
        mixpanel.track("app", properties:  ["callback":"active"])
    }
    
    static func applicationEnteredForeground(){
        mixpanel.track("app", properties:  ["callback":"foreground"])
    }
    
    // User Actions
    
    // Login View
    static func userLogin(){
        mixpanel.track("user", properties:  ["action":"login", "view":"LoginView"])
    }
    
    static func userLogout(){
        mixpanel.track("user", properties:  ["action":"logout", "view":"LoginView"])
    }
    
    // Friends List
    static func userPulledToRefresh(){
        mixpanel.track("user", properties:  ["action":"pull_to_refresh", "view":"InviteFriendsView"])
    }
    
    static func userTappedWithTwoFingers(){
        mixpanel.track("user", properties:  ["action":"two_fingers_tap", "view":"InviteFriendsView"])
    }
    
    static func userTappedWithThreeFingers(){
        mixpanel.track("user", properties:  ["action":"three_fingers_tap", "view":"InviteFriendsView"])
    }
    
    static func userSharedOnFacebook(){
        mixpanel.track("user", properties:  ["action":"share_on_facebook", "view":"InviteFriendsView"])
    }
    
    // Map View
    static func userOpenedOptions(){
        mixpanel.track("user", properties:  ["action":"opened_options", "view":"MapView"])
    }
    
    static func userOpenedNavigation(){
        mixpanel.track("user", properties:  ["action":"navigate_to", "view":"MapView"])
    }
    
    static func userNavigatedWithGoogleMaps(){
        mixpanel.track("user", properties:  ["action":"navigate_with_google", "view":"MapView"])
    }
    
    static func userNavigatedWithAppleMaps(){
        mixpanel.track("user", properties:  ["action":"navigate_with_apple", "view":"MapView"])
    }
    
    static func userCalledFriend(){
        mixpanel.track("user", properties:  ["action":"called_friend", "view":"MapView"])
    }
    
    static func userTerminatedMeetup(){
        mixpanel.track("user", properties:  ["action":"terminated_meetup", "view":"MapView"])
    }
}