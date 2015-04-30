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
        mixpanel.track("{app:closed}")
    }
    
    static func applicationWasOpened() {
        mixpanel.track("{app:opened}")
    }
    
    static func applicationEnteredBackground() {
        mixpanel.track("{app:background}")
    }
    
    static func applicationBecameActive() {
        mixpanel.track("{app:active}")
    }
    
    static func applicationEnteredForeground(){
        mixpanel.track("{app:foreground}")
    }
    
    // User Actions
    
    
    // Login View
    static func userLogin(){
        mixpanel.track("{user:login}")
    }
    
    static func userLogout(){
        mixpanel.track("{user:logout}")
    }
    
    // Friends List
    
    static func userPulledToRefresh(){
        mixpanel.track("{user:pull_to_refresh}")
    }
    
    static func userTappedWithTwoFingers(){
        mixpanel.track("{user:two_fingers_tap}")
    }
    
    static func userTappedWithThreeFingers(){
        mixpanel.track("{user:three_fingers_tap}")
    }
    
}