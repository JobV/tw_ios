//
//  Location.m
//  therewhere
//
//  Created by Marcelo Lebre on 27/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>
#import "SetLocationRequest.h"
#import "SetLocationResponse.h"
#import "Location.h"
#import "TWAPIManager.h"
static NSString *created_date;

@implementation Location{
    RKObjectMapping *setLocationResponseMapping;
    NSIndexSet *statusCodes;
    RKResponseDescriptor *setLocationResponseDescriptor;
    RKObjectMapping *setLocationRequestMapping;
    RKRequestDescriptor *setLocationRequestDescriptor;
    RKObjectManager *rkmanager;
    SetLocationRequest *setLocationRequest;
    NSDateFormatter *dateFormat;
    NSDate *date;
    NSString *restPath ;

}

-(id)init {
    if ( self = [super init] ) {
        restPath = @"/api/v1/location";
        statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
        
        rkmanager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[TWAPIManager twAPI_ip]]];
        
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    return self;
}
- (NSDate *) setLocation: (CLLocationCoordinate2D) coordinate userID:(int)userID{
    
    
    setLocationResponseMapping = [RKObjectMapping mappingForClass:[SetLocationResponse class]];
    [setLocationResponseMapping addAttributeMappingsFromDictionary:@{
                                                          @"locationID":   @"id",
                                                          @"longlat":    @"longlat",
                                                          @"userID":    @"user_id",
                                                          @"created_at":    @"created_at",
                                                          @"updated_at":    @"updated_at"
                                                          }];
    
    setLocationResponseDescriptor = [RKResponseDescriptor
                                     responseDescriptorWithMapping:setLocationResponseMapping
                                     method:RKRequestMethodAny
                                     pathPattern:nil
                                     keyPath:nil
                                     statusCodes:statusCodes];
    
    setLocationRequestMapping = [RKObjectMapping requestMapping];
    [setLocationRequestMapping addAttributeMappingsFromDictionary:@{
                                                         @"userID":   @"id",
                                                         @"x":    @"x",
                                                         @"y":    @"y",
                                                         @"z":    @"z",
                                                         @"m":    @"m"
                                                         }];
    
    setLocationRequestDescriptor = [RKRequestDescriptor
                                    requestDescriptorWithMapping:setLocationRequestMapping
                                    objectClass:[SetLocationRequest class]
                                    rootKeyPath:nil
                                    method:RKRequestMethodAny];
    
    [rkmanager addRequestDescriptor:setLocationRequestDescriptor];
    [rkmanager addResponseDescriptor:setLocationResponseDescriptor];
    
    setLocationRequest = [SetLocationRequest new];
    setLocationRequest.userID = userID;
    setLocationRequest.x = [[NSNumber numberWithDouble:coordinate.longitude] stringValue];
    setLocationRequest.y = [[NSNumber numberWithDouble:coordinate.latitude] stringValue];;

    // POST to create
    [rkmanager postObject:setLocationRequest path:restPath
               parameters:nil
                  success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                      SetLocationResponse *locationResponse = [result firstObject];
                      created_date = locationResponse.created_at;
                  }
                  failure:nil];
    date = [dateFormat dateFromString:created_date];
    
    [rkmanager removeRequestDescriptor:setLocationRequestDescriptor];
    [rkmanager removeResponseDescriptor: setLocationResponseDescriptor];
    return date;
}
@end