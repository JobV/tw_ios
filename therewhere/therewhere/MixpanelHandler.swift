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
    
    static func userOpensApplication() {
        mixpanel.track("{user:application_openned}")
    }
}