//
//  LocationResponse.h
//  therewhere
//
//  Created by Marcelo Lebre on 26/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#ifndef therewhere_LocationResponse_h
#define therewhere_LocationResponse_h

@interface SetLocationResponse : NSObject
@property (nonatomic, assign) int locationID;
@property (nonatomic, assign) int userID;
@property (nonatomic, copy)  NSString *longlat;
@property (nonatomic, copy)  NSString *created_at;
@property (nonatomic, copy)  NSString *updated_at;

@end

#endif
