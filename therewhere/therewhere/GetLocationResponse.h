
//
//  GetLocationRequest.h
//  therewhere
//
//  Created by Marcelo Lebre on 27/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#ifndef therewhere_GetLocationRequest_h
#define therewhere_GetLocationRequest_h

#import <Foundation/Foundation.h>
#import "GetLocationResponse.h"
#import <CoreLocation/CoreLocation.h>
#endif
@interface GetLocationResponse : NSObject

@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *altitude;
@property (nonatomic, copy) NSString *m;

@end