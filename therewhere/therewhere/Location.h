//
//  Location.h
//  therewhere
//
//  Created by Marcelo Lebre on 27/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//


#ifndef therewhere_Location_h
#define therewhere_Location_h
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject
- (NSDate *) setLocation: (CLLocationCoordinate2D) coordinate userID:(int)userID;
- (CLLocationCoordinate2D) getLocation: (int) userID;

@end

#endif
