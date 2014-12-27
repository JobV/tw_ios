//
//  LocationRequest.h
//  therewhere
//
//  Created by Marcelo Lebre on 26/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#ifndef therewhere_LocationRequest_h
#define therewhere_LocationRequest_h


@interface SetLocationRequest : NSObject
@property (nonatomic, assign) int userID;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *z;
@property (nonatomic, copy) NSString *m;
@end
#endif
